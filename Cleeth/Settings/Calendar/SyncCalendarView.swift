// swiftlint:disable line_length
import SwiftUI

struct SyncCalendarView: View {
	var eventModel: EventModel = EventModel()
	@State var showingDialogEventCalendar: Bool = false

	var body: some View {
		Button(action: {
			print("Sync Calendar Button tapped!")
			self.eventModel.requestAccessForCalendar()
			print("Function Requesting Access Success")
			self.showingDialogEventCalendar.toggle()
		}) {
			HStack {
				Image(systemName: "calendar")
					.foregroundStyle(Color(.cleethGreen))
				Text("Sync with Calendar")
					.foregroundStyle(Color.primary)
			}
		}
		.confirmationDialog(
			"Do you want to Sync with Calendar?",
			isPresented: self.$showingDialogEventCalendar,
			titleVisibility: .visible,
			actions: {
				Button("Yes, Sync Now") {
					print("Sync with Calendar Confirmation Dialog Button Tapped")
					self.eventModel.deleteCalendarEvents()
					self.eventModel.addEventsToCalendar()
				}
				.keyboardShortcut(.defaultAction)

				// Button("Yes, but let me Configure") {}

				Button("Cancel", role: .cancel) {
					print("Cancel Sync with Calendar")
				}
			},
			message: {
				Text(
					"Cleeth will create Events for each time of the day you set to be reminded to Brush your Teeth on your Calendar (1 month).\n\nNote: Previous Events set up by Cleeth will be Deleted and Replaced with the new configuration."
				)
			}
		)
	}
}

struct SyncCalendarView_Previews: PreviewProvider {
	static var previews: some View {
		SyncCalendarView()
			.environmentObject(BrushModel())
	}
}
// swiftlint:enable line_length
