import ComposableArchitecture
import SwiftUI

@ViewAction(for: NotificationsReducer.self)
struct NotificationsView: View {
	@Bindable var store: StoreOf<NotificationsReducer>

	var body: some View {
		List {
			permissionsSection

			scheduleSection
		}
		.navigationTitle("Notifications")
		.navigationBarTitleDisplayMode(.large)
		.onAppear { send(.onAppear) }
		.onDisappear { send(.onDisappear) }
	}
}

// MARK: - Subviews
extension NotificationsView {
	private var permissionsSection: some View {
		Section(header: Text("Notifications Permissions")) {
			Button {
				send(.onEnableNotificationsTapped)
			} label: {
				Text(store.isPermissionGranted ? "Access Already Granted" : "Enable Notifications in Settings")
			}
			.foregroundStyle(store.isPermissionGranted ? Color.gray : Color(.cleethGreen))
			.disabled(store.isPermissionGranted)
		}
	}

	private var scheduleSection: some View {
		Section(header: Text("Notifications Schedule")) {
			Picker(
				"Times Per Day",
				systemImage: "timer",
				selection: Binding(
					get: { store.timesPerDay },
					set: { send(.onTimesPerDayChanged($0)) }
				)
			) {
				ForEach(2..<7, id: \.self) { Text("\($0) times") }
			}

			ForEach(0..<store.timesPerDay, id: \.self) { index in
				DatePicker(
					"\(index + 1). notification",
					selection: Binding(
						get: { store.dates[index] },
						set: { send(.onDateChanged(index: index, date: $0)) }
					),
					displayedComponents: [.hourAndMinute]
				)
			}
		}
	}
}

// MARK: - Previews
#Preview {
	NavigationView {
		NotificationsView(
			store: .init(
				initialState: .init(),
				reducer: { NotificationsReducer() }
			)
		)
	}
}
