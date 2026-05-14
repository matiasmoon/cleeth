import EventKit
import Foundation

struct RemindersService {
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
extension RemindersService {
	static var live: Self {
		.init(
			checkPermission: {
				EKEventStore.authorizationStatus(for: .reminder) == .fullAccess
			},
			requestAccess: {
				let status = EKEventStore.authorizationStatus(for: .reminder)
				guard status != .fullAccess else { return }
				_ = try? await EKEventStore().requestFullAccessToReminders()
			},
			sync: {
				addReminders(store: EKEventStore())
			},
			clear: {
				await deleteReminders(store: EKEventStore())
			}
		)
	}
}

// MARK: - Test
extension RemindersService {
	static var test: Self {
		.init(
			checkPermission: {
				fatalError("`remindersService.checkPermission` is unimplemented — override in your TestStore.")
			},
			requestAccess: {
				fatalError("`remindersService.requestAccess` is unimplemented — override in your TestStore.")
			},
			sync: {
				fatalError("`remindersService.sync` is unimplemented — override in your TestStore.")
			},
			clear: {
				fatalError("`remindersService.clear` is unimplemented — override in your TestStore.")
			}
		)
	}
}

// MARK: - Mock
extension RemindersService {
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
private func addReminders(store: EKEventStore) {
	let timesPerDay = UserDefaults.standard.integer(forKey: Keys.timesPerDay)
	let duration = UserDefaults.standard.integer(forKey: Keys.clockDefaultValue) / 60
	for index in 1...6 where index <= timesPerDay {
		guard let date = UserDefaults.standard.object(forKey: Keys.date(index)) as? Date else { continue }
		let hour = Calendar.current.component(.hour, from: date)
		let minute = Calendar.current.component(.minute, from: date)
		addReminder(
			store: store,
			title: "Cleeth: \(ordinalLabel(index)) Brush Of The Day! (\(index)/\(timesPerDay))",
			startHour: hour,
			startMinute: minute,
			duration: duration
		)
	}
}

private func addReminder(store: EKEventStore, title: String, startHour: Int, startMinute: Int, duration: Int) {
	let reminder = EKReminder(eventStore: store)
	reminder.title = title
	reminder.calendar = store.defaultCalendarForNewReminders()
	reminder.startDateComponents = DateComponents(
		year: Calendar.current.component(.year, from: .now),
		month: Calendar.current.component(.month, from: .now),
		day: Calendar.current.component(.day, from: .now),
		hour: startHour,
		minute: startMinute
	)
	reminder.dueDateComponents = reminder.startDateComponents
	reminder.addAlarm(EKAlarm(relativeOffset: TimeInterval(-60 * 5)))
	reminder.recurrenceRules = [
		EKRecurrenceRule(recurrenceWith: .daily, interval: 1, end: nil)
	]
	try? store.save(reminder, commit: true)
}

private func deleteReminders(store: EKEventStore) async {
	let predicate = store.predicateForReminders(in: nil)
	await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
		store.fetchReminders(matching: predicate) { reminders in
			for reminder in reminders ?? [] where reminder.title?.contains("Cleeth") == true {
				try? store.remove(reminder, commit: false)
			}
			try? store.commit()
			continuation.resume()
		}
	}
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
