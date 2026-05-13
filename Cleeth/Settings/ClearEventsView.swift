import SwiftUI

struct ClearEventsView: View {
	var eventModel: EventModel = EventModel()
	@State var showingDialogClearEventsFromCalendar: Bool = false

	var body: some View {
		ZStack {
			Button(action: {
				print("Clear Events from Calendar & Reminders button pressed")
				self.showingDialogClearEventsFromCalendar.toggle()
			}) {
				HStack {
					Image(systemName: "trash")
					Text("Clear Events from your Calendar & Reminders")
				}
			}
			.foregroundColor(.red)
			.confirmationDialog(
				"Are you sure you want to delete all Clear Cleeth Events to Brush Your Teeth from your Calendar & Reminders?",
				isPresented: self.$showingDialogClearEventsFromCalendar,
				titleVisibility: .visible,
				actions: {
					Button("Yes, Delete All", role: .destructive) {
						print("Yes, Delete All Clear Cleeth Events from Calendar and Reminders App")
						self.eventModel.deleteEvents()
					}
					.keyboardShortcut(.defaultAction)

					Button("Cancel", role: .cancel) {
						print("No")
					}
				}
			)
		}
	}
}

#Preview {
	ClearEventsView()
		.environmentObject(BrushModel())
		.environmentObject(NotificationModel())
}
