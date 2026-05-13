import StoreKit
import SwiftUI

struct SettingsView: View {
	@EnvironmentObject var brushTimeModel: BrushModel
	@State var time: Int = UserDefaults.standard.integer(forKey: "clockDefaultValue") / 60
	@Environment(\.requestReview) var requestReview

	var body: some View {
		NavigationView {
			List {
				Section(header: Text("Time for Every Brush")) {
					Picker(
						"Time",
						systemImage: "timer",
						selection: self.$time,
						content: {
							ForEach(
								2..<11,
								id: \.self,
								content: {
									Text("\($0) minutes")
								}
							)
						}
					)
				}
				.onChange(
					of: self.time,
					{
						self.brushTimeModel.setNewValueForClock(new_value: self.time * 60)
					}
				)

				Section(header: Text("Brush Options")) {
					NavigationLink(destination: NotificationsView()) {
						HStack {
							Image(systemName: "bell.badge")
								.foregroundStyle(Color(.cleethGreen))
							Text("Notifications")
						}
					}

					SyncCalendarView()

					SyncRemindersView()
				}

				Section(header: Text("App Information")) {
					NavigationLink(destination: AboutView()) {
						HStack {
							Image(systemName: "info.circle")
								.foregroundStyle(Color(.cleethGreen))
							Text("About")
						}
						.foregroundStyle(Color.primary)
					}

					NavigationLink(destination: PrivacyPolicyView()) {
						HStack {
							Image(systemName: "person.crop.circle")
								.foregroundStyle(Color(.cleethGreen))
							Text("Privacy Policy")
						}
						.foregroundStyle(Color.primary)
					}

					HStack {
						ShareLink(
							items: [URL(string: "https://apps.apple.com/tr/app/cleeth/id6472682824")!],
							subject: Text("Download Cleeth Now!"),
							message: Text("Hey! Check out this app that helps you remember to brush your teeth!"),
							label: {
								HStack {
									Image(systemName: "square.and.arrow.up")
										.foregroundStyle(Color(.cleethGreen))
									Text("Share")
										.foregroundStyle(Color.primary)
								}
							}
						)
					}

					HStack {
						Button(
							action: {
								requestReview()
							},
							label: {
								HStack {
									Image(systemName: "star")
										.foregroundStyle(Color(.cleethGreen))
									Text("Evaluate")
								}
							}
						)
						.foregroundStyle(Color.primary)
					}

					HStack {
						Button(
							action: {
								EmailHelper.shared.sendEmail(
									subject: "Inquiry about Cleeth 🪥",
									body: "Hello Matias!\nI want to contact you ...",
									toRecipients: "matiasortizluna.contacto@gmail.com",
									completion: { _ in
										print("MailView presented")
									}
								)
							},
							label: {
								HStack {
									Image(systemName: "envelope.badge")
										.foregroundStyle(Color(.cleethGreen))
									Text("Feedback & Support")
										.foregroundStyle(Color.primary)
								}
							}
						)
					}
				}

				Section(header: Text("Reset Options")) {
					// ClearStatisticsView()

					ClearEventsView()
				}

				Section {
					HStack {
						Text("App Version")
						Spacer()
						Text("1.2P")
					}
				}
			}
			.listStyle(.insetGrouped)
			.navigationTitle("Settings")
			.navigationBarTitleDisplayMode(.large)
		}
	}
}

struct SettingsView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsView()
			.environmentObject(BrushModel())
			.environmentObject(NotificationModel())
	}
}
