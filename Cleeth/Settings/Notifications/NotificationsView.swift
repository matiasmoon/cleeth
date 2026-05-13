import SwiftUI

struct NotificationsView: View {
	@EnvironmentObject var notificationViewModel: NotificationModel

	var body: some View {
		List {
			Section(header: Text("Notifications Permissions")) {
				Button(
					action: {
						if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
							UIApplication.shared.open(settingsURL)
						}
					},
					label: {
						Text(self.notificationViewModel.notificationsProvided == true ? "Access Already Granted" : "Enable Notifications in Settings")
					}
				)
				.foregroundStyle(self.notificationViewModel.notificationsProvided == true ? Color.gray : Color(.cleethGreen))
				.disabled(self.notificationViewModel.notificationsProvided == true)
			}

			Section(header: Text("Notifications Schedule")) {
				Picker(
					"Times Per Day",
					systemImage: "timer",
					selection: self.$notificationViewModel.timesPerDay,
					content: {
						ForEach(
							2..<7,
							id: \.self,
							content: {
								Text("\($0) times")
							}
						)
					}
				)

				if 1 <= self.notificationViewModel.timesPerDay {
					DatePicker("1st time: ", selection: self.$notificationViewModel.date1, displayedComponents: [.hourAndMinute])
				}
				if 2 <= self.notificationViewModel.timesPerDay {
					DatePicker("2nd time: ", selection: self.$notificationViewModel.date2, displayedComponents: [.hourAndMinute])
				}
				if 3 <= self.notificationViewModel.timesPerDay {
					DatePicker("3rd time: ", selection: self.$notificationViewModel.date3, displayedComponents: [.hourAndMinute])
				}
				if 4 <= self.notificationViewModel.timesPerDay {
					DatePicker("4th time: ", selection: self.$notificationViewModel.date4, displayedComponents: [.hourAndMinute])
				}
				if 5 <= self.notificationViewModel.timesPerDay {
					DatePicker("5th time: ", selection: self.$notificationViewModel.date5, displayedComponents: [.hourAndMinute])
				}
				if 6 <= self.notificationViewModel.timesPerDay {
					DatePicker("6th time: ", selection: self.$notificationViewModel.date6, displayedComponents: [.hourAndMinute])
				}
			}
		}
		.navigationTitle("Notifications")
		.navigationBarTitleDisplayMode(.large)
		.onChange(
			of: self.notificationViewModel.timesPerDay,
			{
				self.notificationViewModel.setNewValuesOfNotifications()
			}
		)
		.onDisappear(perform: {
			self.notificationViewModel.scheduleNotifications()
		})
	}
}

struct NotificationsView_Previews: PreviewProvider {
	static var previews: some View {
		NotificationsView()
			.environmentObject(BrushModel())
			.environmentObject(NotificationModel())
	}
}
