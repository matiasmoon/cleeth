import EventKit
import Foundation

class EventModel {
	let eventStore = EKEventStore()
	let todayDate: Date = Date()

	/// Requests access to the user's calendar.
	///
	func requestAccessForCalendar() {
		let status = EKEventStore.authorizationStatus(for: .event)
		if status == .authorized {
			print("EKEventStore access already granted.")
		} else {
			eventStore.requestFullAccessToEvents { success, error in
				if success && error == nil {
					print("EKEventStore access has been granted.")
				} else {
					print("EKEventStore access request failed with error: \(error?.localizedDescription ?? "Unknown error")")
				}
			}
		}
	}

	/// Adds events to the user's calendar based on saved user settings.
	///
	func addEventsToCalendar() {
		let timesPerDay: Int = UserDefaults.standard.integer(forKey: "timesPerDay")
		let duration: Int = UserDefaults.standard.integer(forKey: "clockDefaultValue") / 60

		var date: Date = UserDefaults.standard.object(forKey: "date1") as! Date
		var hour: Int = 0
		var minute: Int = 0

		if 1 <= timesPerDay {
			hour = Calendar.current.component(.hour, from: date)
			minute = Calendar.current.component(.minute, from: date)
			self.addEventToCalendar(title: "Cleeth: 1st Brush Of The Day! (1/\(timesPerDay))", startHour: hour, startMinute: minute, duration: duration)
		}
		if 2 <= timesPerDay {
			date = UserDefaults.standard.object(forKey: "date2") as! Date
			hour = Calendar.current.component(.hour, from: date)
			minute = Calendar.current.component(.minute, from: date)
			self.addEventToCalendar(title: "Cleeth: 2nd Brush Of The Day! (2/\(timesPerDay))", startHour: hour, startMinute: minute, duration: duration)
		}
		if 3 <= timesPerDay {
			date = UserDefaults.standard.object(forKey: "date3") as! Date
			hour = Calendar.current.component(.hour, from: date)
			minute = Calendar.current.component(.minute, from: date)
			self.addEventToCalendar(title: "Cleeth: 3rd Brush Of The Day! (3/\(timesPerDay))", startHour: hour, startMinute: minute, duration: duration)
		}

		if 4 <= timesPerDay {
			date = UserDefaults.standard.object(forKey: "date4") as! Date
			hour = Calendar.current.component(.hour, from: date)
			minute = Calendar.current.component(.minute, from: date)
			self.addEventToCalendar(title: "Cleeth: 4th Brush Of The Day! (4/\(timesPerDay))", startHour: hour, startMinute: minute, duration: duration)
		}
		if 5 <= timesPerDay {
			date = UserDefaults.standard.object(forKey: "date5") as! Date
			hour = Calendar.current.component(.hour, from: date)
			minute = Calendar.current.component(.minute, from: date)
			self.addEventToCalendar(title: "Cleeth: 5th Brush Of The Day! (5/\(timesPerDay))", startHour: hour, startMinute: minute, duration: duration)
		}
		if 6 <= timesPerDay {
			date = UserDefaults.standard.object(forKey: "date6") as! Date
			hour = Calendar.current.component(.hour, from: date)
			minute = Calendar.current.component(.minute, from: date)
			self.addEventToCalendar(title: "Cleeth: 6th Brush Of The Day! (6/\(timesPerDay))", startHour: hour, startMinute: minute, duration: duration)
		}
	}

	/// Adds a single event to the user's calendar.
	///
	/// - Parameters:
	///   - title: The title of the event.
	///   - startHour: The hour component of the event's start time.
	///   - startMinute: The minute component of the event's start time.
	///   - duration: The duration of the event in minutes.
	///
	func addEventToCalendar(title: String, startHour: Int, startMinute: Int, duration: Int) {
		let newEvent = EKEvent(eventStore: self.eventStore)
		newEvent.calendar = eventStore.defaultCalendarForNewEvents
		newEvent.title = title
		newEvent.startDate = Calendar.current.date(bySettingHour: startHour, minute: startMinute, second: 0, of: Date())
		newEvent.endDate = Calendar.current.date(bySetting: .minute, value: startMinute + duration, of: newEvent.startDate)

		let alarm = EKAlarm(relativeOffset: TimeInterval(-60 * 5))
		newEvent.addAlarm(alarm)

		let recurrenceRule = EKRecurrenceRule(
			recurrenceWith: EKRecurrenceFrequency.daily,
			interval: 1,
			end: EKRecurrenceEnd(end: Calendar.current.date(byAdding: .month, value: 1, to: newEvent.startDate)!)
		)
		newEvent.recurrenceRules = [recurrenceRule]

		do {
			try eventStore.save(newEvent, span: .thisEvent)
		} catch let error as NSError {
			print("Error saving event in calendar. \(error)")
			return
		}
	}

	/// Deletes all 'Cleeth' events from the user's calendar.
	///
	func deleteCalendarEvents() {
		let predicate = eventStore.predicateForEvents(
			withStart: Calendar.current.date(from: DateComponents(year: 2023, month: 11, day: 19))!,
			end: Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 1))!,
			calendars: [eventStore.defaultCalendarForNewEvents ?? EKCalendar()]
		)
		let existingEvents = eventStore.events(matching: predicate)

		for event in existingEvents {
			if event.title.contains("Cleeth") {
				do {
					try eventStore.remove(event, span: .futureEvents)
				} catch let error as NSError {
					print("Failed to save event with error : \(error)")
				}
				print("Removed Event")
			} else {
				print("Event does not start with Cleeth")
			}
		}
	}

	/// Requests access to the user's reminders.
	///
	func requestAccessForReminders() {
		let status = EKEventStore.authorizationStatus(for: .reminder)
		if status == .authorized {
			print("EKEventStore access for Reminders already granted.")
		} else {
			eventStore.requestFullAccessToReminders { success, error in
				if success && error == nil {
					print("EKEventStore access for Reminders has been granted.")
				} else {
					print("EKEventStore access for Reminders request failed with error: \(error?.localizedDescription ?? "Unknown error")")
				}
			}
		}
	}

	/// Adds events to the user's reminders based on saved user settings.
	///
	func addEventsToReminders() {
		let timesPerDay: Int = UserDefaults.standard.integer(forKey: "timesPerDay")
		let duration: Int = UserDefaults.standard.integer(forKey: "clockDefaultValue") / 60

		var date: Date = UserDefaults.standard.object(forKey: "date1") as! Date
		var hour: Int = 0
		var minute: Int = 0

		if 1 <= timesPerDay {
			hour = Calendar.current.component(.hour, from: date)
			minute = Calendar.current.component(.minute, from: date)
			self.addEventToReminders(title: "Cleeth: 1st Brush Of The Day! (1/\(timesPerDay))", startHour: hour, startMinute: minute, duration: duration)
		}
		if 2 <= timesPerDay {
			date = UserDefaults.standard.object(forKey: "date2") as! Date
			hour = Calendar.current.component(.hour, from: date)
			minute = Calendar.current.component(.minute, from: date)
			self.addEventToReminders(title: "Cleeth: 2nd Brush Of The Day! (2/\(timesPerDay))", startHour: hour, startMinute: minute, duration: duration)
		}
		if 3 <= timesPerDay {
			date = UserDefaults.standard.object(forKey: "date3") as! Date
			hour = Calendar.current.component(.hour, from: date)
			minute = Calendar.current.component(.minute, from: date)
			self.addEventToReminders(title: "Cleeth: 3rd Brush Of The Day! (3/\(timesPerDay))", startHour: hour, startMinute: minute, duration: duration)
		}
		if 4 <= timesPerDay {
			date = UserDefaults.standard.object(forKey: "date4") as! Date
			hour = Calendar.current.component(.hour, from: date)
			minute = Calendar.current.component(.minute, from: date)
			self.addEventToReminders(title: "Cleeth: 4th Brush Of The Day! (4/\(timesPerDay))", startHour: hour, startMinute: minute, duration: duration)
		}
		if 5 <= timesPerDay {
			date = UserDefaults.standard.object(forKey: "date5") as! Date
			hour = Calendar.current.component(.hour, from: date)
			minute = Calendar.current.component(.minute, from: date)
			self.addEventToReminders(title: "Cleeth: 5th Brush Of The Day! (5/\(timesPerDay))", startHour: hour, startMinute: minute, duration: duration)
		}
		if 6 <= timesPerDay {
			date = UserDefaults.standard.object(forKey: "date6") as! Date
			hour = Calendar.current.component(.hour, from: date)
			minute = Calendar.current.component(.minute, from: date)
			self.addEventToReminders(title: "Cleeth: 6th Brush Of The Day! (6/\(timesPerDay))", startHour: hour, startMinute: minute, duration: duration)
		}
	}

	/// Adds a single event to the user's reminders.
	///
	/// - Parameters:
	///   - title: The title of the reminder.
	///   - startHour: The hour component of the reminder's start time.
	///   - startMinute: The minute component of the reminder's start time.
	///   - duration: The duration of the reminder in minutes.
	///
	func addEventToReminders(title: String, startHour: Int, startMinute: Int, duration: Int) {
		let newEvent = EKReminder(eventStore: self.eventStore)

		newEvent.title = title
		print("newEvent1 \(newEvent)")
		newEvent.calendar = self.eventStore.defaultCalendarForNewReminders()
		print("newEvent2 \(newEvent)")
		// newEvent.startDateComponents = DateComponents(year: Calendar.current.component(.year, from: Date()), month: Calendar.current.component(.month, from: Date()), day: Calendar.current.component(.day, from: Date()), hour: startHour,minute: startMinute)

		// newEvent.dueDateComponents = DateComponents(year: newEvent.startDateComponents!.year, month: newEvent.startDateComponents!.month, day: newEvent.startDateComponents!.day, hour: newEvent.startDateComponents!.hour, minute: newEvent.startDateComponents!.minute)

		print("newEvent2 \(newEvent)")

		// let alarm = EKAlarm(relativeOffset: TimeInterval(-60 * 5))
		// newEvent.addAlarm(alarm)

		// let recurrenceRule = EKRecurrenceRule(recurrenceWith: EKRecurrenceFrequency.daily, interval: 1, end: EKRecurrenceEnd(end: Calendar.current.date(byAdding: .month, value: 1, to: newEvent.completionDate!)!))
		// newEvent.recurrenceRules = [recurrenceRule]

		do {
			try eventStore.save(
				newEvent,
				commit: true
			)
		} catch let error {
			print("Reminder failed with error \(error.localizedDescription)")
		}
	}

	/// Deletes all 'Cleeth' events from both calendar and reminders.
	///
	func deleteEvents() {
		self.deleteCalendarEvents()
		self.deleteRemindersEvents(complete: true)
		self.deleteRemindersEvents(complete: false)
	}

	/// Deletes all 'Cleeth' events from the user's reminders.
	///
	/// - Parameter complete: Flag to specify whether to delete completed or incomplete reminders.
	///
	func deleteRemindersEvents(complete: Bool = false) {
		var predicate: NSPredicate
		if complete {
			predicate = self.eventStore.predicateForCompletedReminders(
				withCompletionDateStarting: Calendar.current.date(from: DateComponents(year: 2023, month: 11, day: 19))!,
				ending: Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 1))!,
				calendars: [eventStore.defaultCalendarForNewEvents ?? EKCalendar()]
			)
		} else {
			predicate = self.eventStore.predicateForIncompleteReminders(
				withDueDateStarting: Calendar.current.date(from: DateComponents(year: 2023, month: 11, day: 19))!,
				ending: Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 1))!,
				calendars: [eventStore.defaultCalendarForNewEvents ?? EKCalendar()]
			)
		}

		let existingEvents = eventStore.events(matching: predicate)
		for event in existingEvents {
			if event.title.contains("Cleeth") {
				do {
					try eventStore.remove(event, span: .futureEvents)
				} catch let error as NSError {
					print("Failed to save event with error : \(error)")
				}
				print("Removed Event")
			} else {
				print("Event does not start with Cleeth")
			}
		}
	}
}
