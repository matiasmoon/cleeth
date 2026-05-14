import ComposableArchitecture
import Foundation
import UserNotifications

struct NotificationsService {
	var load: @Sendable () -> (timesPerDay: Int, dates: [Date])
	var checkPermission: @Sendable () async -> Bool
	var scheduleNotifications: @Sendable ([Date], Int) async -> Void

	init(
		load: @Sendable @escaping () -> (timesPerDay: Int, dates: [Date]),
		checkPermission: @Sendable @escaping () async -> Bool,
		scheduleNotifications: @Sendable @escaping ([Date], Int) async -> Void
	) {
		self.load = load
		self.checkPermission = checkPermission
		self.scheduleNotifications = scheduleNotifications
	}
}

// MARK: - Live
extension NotificationsService {
	static var live: Self {
		.init(
			load: {
				let timesPerDay = UserDefaults.standard.integer(forKey: Keys.timesPerDay)
				let dates: [Date] = (1...6).map {
					(UserDefaults.standard.object(forKey: Keys.date($0)) as? Date)
						?? Calendar.current.date(from: DateComponents(hour: 8)) ?? .now
				}
				return (timesPerDay: timesPerDay >= 2 ? timesPerDay : 2, dates: dates)
			},
			checkPermission: {
				let settings = await UNUserNotificationCenter.current().notificationSettings()
				return settings.authorizationStatus == .authorized
			},
			scheduleNotifications: { dates, timesPerDay in
				let center = UNUserNotificationCenter.current()
				center.removeAllDeliveredNotifications()
				center.removeAllPendingNotificationRequests()

				UserDefaults.standard.set(timesPerDay, forKey: Keys.timesPerDay)

				for index in 0..<timesPerDay {
					let date = dates[index]
					let hour = Calendar.current.component(.hour, from: date)
					let minute = Calendar.current.component(.minute, from: date)
					UserDefaults.standard.set(date, forKey: Keys.date(index + 1))

					let content = UNMutableNotificationContent()
					content.title = "Time To Brush Your Teeth!"
					content.body = "Don't miss your \(ordinalLabel(index + 1)) Brush of the Day! (\(index + 1)/\(timesPerDay))"
					content.badge = 1
					content.sound = .default

					let trigger = UNCalendarNotificationTrigger(
						dateMatching: DateComponents(hour: hour, minute: minute),
						repeats: true
					)

					let request = UNNotificationRequest(
						identifier: UUID().uuidString,
						content: content,
						trigger: trigger
					)

					try? await center.add(request)
				}
			}
		)
	}
}

// MARK: - Helpers
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
	static func date(_ index: Int) -> String { "date\(index)" }
}

// MARK: - Test
extension NotificationsService {
	static var test: Self {
		.init(
			load: {
				fatalError("`notificationsService.load` is unimplemented — override in your TestStore.")
			},
			checkPermission: {
				fatalError("`notificationsService.checkPermission` is unimplemented — override in your TestStore.")
			},
			scheduleNotifications: { _, _ in
				fatalError("`notificationsService.scheduleNotifications` is unimplemented — override in your TestStore.")
			}
		)
	}
}

// MARK: - Mock
extension NotificationsService {
	static var mock: Self {
		.init(
			load: { (timesPerDay: 2, dates: Array(repeating: .now, count: 6)) },
			checkPermission: { false },
			scheduleNotifications: { _, _ in }
		)
	}
}
