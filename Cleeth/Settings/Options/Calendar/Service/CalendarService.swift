import EventKit
import Foundation

struct CalendarService {
	var checkPermission: @Sendable () -> Bool
	var requestAccess: @Sendable () async -> Void
	var sync: @Sendable () async -> Void
	var clear: @Sendable () async -> Void

	init(
		checkPermission: @Sendable @escaping () -> Bool,
		requestAccess: @Sendable @escaping () async -> Void,
		sync: @Sendable @escaping () async -> Void,
		clear: @Sendable @escaping () async -> Void
	) {
		self.checkPermission = checkPermission
		self.requestAccess = requestAccess
		self.sync = sync
		self.clear = clear
	}
}

// MARK: - Live
extension CalendarService {
	static var live: Self {
		.init(
			checkPermission: {
				EKEventStore.authorizationStatus(for: .event) == .fullAccess
			},
			requestAccess: {
				let status = EKEventStore.authorizationStatus(for: .event)
				guard status != .fullAccess else { return }
				_ = try? await EKEventStore().requestFullAccessToEvents()
			},
			sync: {
				let store = EKEventStore()
				deleteEvents(store: store)
				addEvents(store: store)
			},
			clear: {
				deleteEvents(store: EKEventStore())
			}
		)
	}
}

// MARK: - Test
extension CalendarService {
	static var test: Self {
		.init(
			checkPermission: {
				fatalError("`calendarService.checkPermission` is unimplemented — override in your TestStore.")
			},
			requestAccess: {
				fatalError("`calendarService.requestAccess` is unimplemented — override in your TestStore.")
			},
			sync: {
				fatalError("`calendarService.sync` is unimplemented — override in your TestStore.")
			},
			clear: {
				fatalError("`calendarService.clear` is unimplemented — override in your TestStore.")
			}
		)
	}
}

// MARK: - Mock
extension CalendarService {
	static var mock: Self {
		.init(
			checkPermission: { false },
			requestAccess: {},
			sync: {},
			clear: {}
		)
	}
}

// MARK: - Helpers
private func deleteEvents(store: EKEventStore) {
	let predicate = store.predicateForEvents(
		withStart: Calendar.current.date(from: DateComponents(year: 2023, month: 11, day: 19))!,
		end: Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 1))!,
		calendars: store.defaultCalendarForNewEvents.map { [$0] }
	)
	for event in store.events(matching: predicate) where event.title.contains("Cleeth") {
		try? store.remove(event, span: .futureEvents)
	}
}

private func addEvents(store: EKEventStore) {
	let timesPerDay = UserDefaults.standard.integer(forKey: Keys.timesPerDay)
	let duration = UserDefaults.standard.integer(forKey: Keys.clockDefaultValue) / 60
	for index in 1...6 where index <= timesPerDay {
		guard let date = UserDefaults.standard.object(forKey: Keys.date(index)) as? Date else { continue }
		let hour = Calendar.current.component(.hour, from: date)
		let minute = Calendar.current.component(.minute, from: date)
		addEvent(
			store: store,
			title: "Cleeth: \(ordinalLabel(index)) Brush Of The Day! (\(index)/\(timesPerDay))",
			startHour: hour,
			startMinute: minute,
			duration: duration
		)
	}
}

private func addEvent(store: EKEventStore, title: String, startHour: Int, startMinute: Int, duration: Int) {
	guard let startDate = Calendar.current.date(bySettingHour: startHour, minute: startMinute, second: 0, of: .now)
	else { return }
	let event = EKEvent(eventStore: store)
	event.calendar = store.defaultCalendarForNewEvents
	event.title = title
	event.startDate = startDate
	event.endDate = Calendar.current.date(bySetting: .minute, value: startMinute + duration, of: startDate)
	event.addAlarm(EKAlarm(relativeOffset: TimeInterval(-60 * 5)))
	event.recurrenceRules = [
		EKRecurrenceRule(
			recurrenceWith: .daily,
			interval: 1,
			end: EKRecurrenceEnd(end: Calendar.current.date(byAdding: .month, value: 1, to: startDate)!)
		)
	]
	try? store.save(event, span: .thisEvent)
}

private func ordinalLabel(_ index: Int) -> String {
	switch index {
	case 1: "1st"
	case 2: "2nd"
	case 3: "3rd"
	default: "\(index)th"
	}
}

private enum Keys {
	static let timesPerDay = "timesPerDay"
	static let clockDefaultValue = "clockDefaultValue"
	static func date(_ index: Int) -> String { "date\(index)" }
}
