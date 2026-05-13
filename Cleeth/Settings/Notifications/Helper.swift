import Foundation
import MessageUI
import UserNotifications

class Helper {
	/// Requests permission for user notifications.
	///
	/// This method requests authorization for notifications with options for alert, sound, and badge.
	/// Upon receiving the user's response, it updates the user defaults with the notification permission status.
	///
	static func requestNotificationsPermission() {
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
			DispatchQueue.main.async {
				if granted {
					print("Notification permission granted")
					UserDefaults.standard.setValue(true, forKey: "notificationsProvided")
				} else if let error = error {
					print("Error requesting notification permission: \(error.localizedDescription)")
					UserDefaults.standard.setValue(false, forKey: "notificationsProvided")
				} else {
					print("Notification permission denied")
					UserDefaults.standard.setValue(false, forKey: "notificationsProvided")
				}
			}
		}
	}
}
