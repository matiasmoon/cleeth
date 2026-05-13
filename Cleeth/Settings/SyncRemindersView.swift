// swiftlint:disable line_length
import SwiftUI

struct SyncRemindersView: View {
	var eventModel: EventModel = EventModel()
	@State var showingDialogEventReminders: Bool = false

	var body: some View {
		Button(action: {
			print("Sync Reminders Button tapped!")
			self.eventModel.requestAccessForReminders()
			print("Function Requesting Access Success")
			self.showingDialogEventReminders.toggle()
		}) {
			HStack {
				Image(systemName: "list.bullet.clipboard")
					.foregroundStyle(Color(.cleethGreen))
				Text("Sync with Reminders")
					.foregroundStyle(Color.primary)
			}
		}
		.confirmationDialog(
			"Do you want to Sync with Reminders?",
			isPresented: self.$showingDialogEventReminders,
			titleVisibility: .visible,
			actions: {
				Button("Yes, Sync Now") {
					print("Sync with Reminders Confirmation Dialog Button Tapped")
					// self.eventModel.deleteRemindersEvents()
					self.eventModel.addEventsToReminders()
				}
				.keyboardShortcut(.defaultAction)

				// Button("Yes, but let me Configure") {}

				Button("Cancel", role: .cancel) {
					print("Cancel Sync with Reminders")
				}
			},
			message: {
				Text(
					"Cleeth will create a Reminder for each time of the day you set to be reminded to Brush your Teeth on the Reminders App (1 month).\n\nNote: Previous Events set up by Cleeth will be Deleted and Replaced with the new configuration."
				)
			}
		)
	}
}

#Preview {
	SyncRemindersView()
}
// swiftlint:enable line_length
