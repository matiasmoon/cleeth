import SwiftUI

struct ClearStatisticsView: View {
	@State var showingDialogClearStatistics: Bool = false

	var body: some View {
		ZStack {
			Button(action: {
				print("Clear Statistics button pressed")
				self.showingDialogClearStatistics.toggle()
			}) {
				HStack {
					Image(systemName: "trash")
					Text("Clear Statistics")
				}
			}
			.foregroundColor(.red)
			.confirmationDialog(
				"Are you sure you want to add Events to Brush Your Teeth to your Calendar?",
				isPresented: self.$showingDialogClearStatistics,
				titleVisibility: .visible,
				actions: {
					Button("Yes") {
						print("Yes")
					}

					Button("Yes, Delete All", role: .destructive) {
						print("Yes")
					}
					.keyboardShortcut(.defaultAction)

					Button("Cancel", role: .cancel) {
						print("No")
					}
				},
				message: {
					Text("Hello")
				}
			)
		}
	}
}

struct ClearStatisticsView_Previews: PreviewProvider {
	static var previews: some View {
		ClearStatisticsView()
			.environmentObject(BrushModel())
			.environmentObject(NotificationModel())
	}
}
