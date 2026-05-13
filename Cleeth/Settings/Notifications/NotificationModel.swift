import Foundation
import UserNotifications

class NotificationModel: ObservableObject {
	var badgeCount: Int = 0

	@Published var notificationsProvided: Bool = UserDefaults.standard.bool(forKey: "notificationsProvided")

	@Published var timesPerDay: Int = UserDefaults.standard.integer(forKey: "timesPerDay")

	@Published var date1: Date = UserDefaults.standard.object(forKey: "date1") as! Date
	@Published var date2: Date = UserDefaults.standard.object(forKey: "date2") as! Date
	@Published var date3: Date = UserDefaults.standard.object(forKey: "date3") as! Date
	@Published var date4: Date = UserDefaults.standard.object(forKey: "date4") as! Date
	@Published var date5: Date = UserDefaults.standard.object(forKey: "date5") as! Date
	@Published var date6: Date = UserDefaults.standard.object(forKey: "date6") as! Date

	/// Returns the current badge count.
	///
	/// - Returns: The current badge count as an integer.
	///
	func getBadgeCount() -> Int {
		return self.badgeCount
	}

	/// Sets a new badge count value.
	///
	/// - Parameter newValue: The new badge count value.
	///
	func setBadgeCount(newValue: Int) {
		self.badgeCount = newValue
	}

	/// Calculates and sets new notification dates based on the number of times per day.
	///
	/// This function sets the notification dates (`date1` to `date6`) based on the `timesPerDay` and specific times.
	///
	func setNewValuesOfNotifications() {
		self.date1 = Calendar.current.date(from: DateComponents(hour: self.calculateTimesBasedOnNumberOfTimes(timesPerDay: self.timesPerDay, time: 1)))!
		self.date2 = Calendar.current.date(from: DateComponents(hour: self.calculateTimesBasedOnNumberOfTimes(timesPerDay: self.timesPerDay, time: 2)))!
		self.date3 = Calendar.current.date(from: DateComponents(hour: self.calculateTimesBasedOnNumberOfTimes(timesPerDay: self.timesPerDay, time: 3)))!
		self.date4 = Calendar.current.date(from: DateComponents(hour: self.calculateTimesBasedOnNumberOfTimes(timesPerDay: self.timesPerDay, time: 4)))!
		self.date5 = Calendar.current.date(from: DateComponents(hour: self.calculateTimesBasedOnNumberOfTimes(timesPerDay: self.timesPerDay, time: 5)))!
		self.date6 = Calendar.current.date(from: DateComponents(hour: self.calculateTimesBasedOnNumberOfTimes(timesPerDay: self.timesPerDay, time: 6)))!
	}

	/// Calculates the notification time based on the number of times per day and a specific time.
	///
	/// - Parameters:
	///   - timesPerDay: The number of times to schedule notifications per day.
	///   - time: The specific time index for the notification.
	/// - Returns: The hour value for the notification time.
	///
	func calculateTimesBasedOnNumberOfTimes(timesPerDay: Int, time: Int) -> Int {
		switch (timesPerDay, time) {
		case (2, 1):
			return 8
		case (2, 2):
			return 23
		case (3, 1):
			return 8
		case (3, 2):
			return 14
		case (3, 3):
			return 23
		case (4, 1):
			return 8
		case (4, 2):
			return 14
		case (4, 3):
			return 17
		case (4, 4):
			return 23
		case (5, 1):
			return 8
		case (5, 2):
			return 11
		case (5, 3):
			return 14
		case (5, 4):
			return 17
		case (5, 5):
			return 23
		case (6, 1):
			return 8
		case (6, 2):
			return 11
		case (6, 3):
			return 14
		case (6, 4):
			return 17
		case (6, 5):
			return 20
		case (6, 6):
			return 23
		default:
			return 0
		}
	}

	/// Schedules notifications based on the set notification times.
	///
	/// This function schedules notifications using `scheduleNotification(title:body:badge:hour:minute:)` method
	/// based on the `timesPerDay` and specific notification times (`date1` to `date6`).
	///
	func scheduleNotifications() {
		var hour = 0
		var minute = 0

		UNUserNotificationCenter.current().removeAllDeliveredNotifications()
		UNUserNotificationCenter.current().removeAllPendingNotificationRequests()

		UserDefaults.standard.setValue(self.timesPerDay, forKey: "timesPerDay")

		if 1 <= self.timesPerDay {
			hour = Calendar.current.component(.hour, from: date1)
			minute = Calendar.current.component(.minute, from: date1)
			scheduleNotification(
				title: "Time To Brush Your Teeth!",
				body: "Don't miss your 1st Brush of the Day! (1/\(timesPerDay))",
				badge: 1,
				hour: hour,
				minute: minute
			)
			UserDefaults.standard.setValue(date1, forKey: "date1")
		}
		if 2 <= self.timesPerDay {
			hour = Calendar.current.component(.hour, from: date2)
			minute = Calendar.current.component(.minute, from: date2)
			scheduleNotification(
				title: "Time To Brush Your Teeth!",
				body: "Don't miss your 2nd Brush of the Day! (2/\(timesPerDay))",
				badge: 1,
				hour: hour,
				minute: minute
			)
			UserDefaults.standard.setValue(date2, forKey: "date2")
		}
		if 3 <= self.timesPerDay {
			hour = Calendar.current.component(.hour, from: date3)
			minute = Calendar.current.component(.minute, from: date3)
			scheduleNotification(
				title: "Time To Brush Your Teeth!",
				body: "Don't miss your 3rd Brush of the Day! (3/\(timesPerDay))",
				badge: 1,
				hour: hour,
				minute: minute
			)
			UserDefaults.standard.setValue(date3, forKey: "date3")
		}
		if 4 <= self.timesPerDay {
			hour = Calendar.current.component(.hour, from: date4)
			minute = Calendar.current.component(.minute, from: date4)
			scheduleNotification(
				title: "Time To Brush Your Teeth!",
				body: "Don't miss your 4th Brush of the Day! (4/\(timesPerDay))",
				badge: 1,
				hour: hour,
				minute: minute
			)
			UserDefaults.standard.setValue(date4, forKey: "date4")
		}
		if 5 <= self.timesPerDay {
			hour = Calendar.current.component(.hour, from: date5)
			minute = Calendar.current.component(.minute, from: date5)
			scheduleNotification(
				title: "Time To Brush Your Teeth!",
				body: "Don't miss your 5th Brush of the Day! (5/\(timesPerDay))",
				badge: 1,
				hour: hour,
				minute: minute
			)
			UserDefaults.standard.setValue(date5, forKey: "date5")
		}
		if 6 <= self.timesPerDay {
			hour = Calendar.current.component(.hour, from: date6)
			minute = Calendar.current.component(.minute, from: date6)
			scheduleNotification(
				title: "Time To Brush Your Teeth!",
				body: "Don't miss your 6th Brush of the Day! (6/\(timesPerDay))",
				badge: 1,
				hour: hour,
				minute: minute
			)
			UserDefaults.standard.setValue(date6, forKey: "date6")
		}
	}

	/// Schedules a single notification with the provided details.
	///
	/// - Parameters:
	///   - title: The title of the notification.
	///   - body: The body text of the notification.
	///   - badge: The badge count for the notification.
	///   - hour: The hour component of the notification time.
	///   - minute: The minute component of the notification time.
	///
	func scheduleNotification(title: String, body: String, badge: UInt, hour: Int, minute: Int) {
		self.setBadgeCount(newValue: 1)

		let content = UNMutableNotificationContent()
		content.title = title
		content.body = body
		content.badge = NSNumber(value: self.getBadgeCount())
		content.sound = .default

		let components = Calendar.current.dateComponents([.hour, .minute], from: Calendar.current.date(from: DateComponents(hour: hour, minute: minute))!)
		let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

		let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

		UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { success in
			print(success)
		})

		UNUserNotificationCenter.current().requestAuthorization(
			options: [.alert, .sound],
			completionHandler: { granted, error in
				if granted {
					UNUserNotificationCenter.current().add(request) { error in
						if let error = error {
							print("Error scheduling notification: \(error)")
						} else {
							print("Notification at \(hour):\(minute) Scheduled Successfully!")
						}
					}
				} else {
					print("Notification permission denied")
				}
			}
		)
	}
}
