import ComposableArchitecture
import SwiftUI

@ViewAction(for: CalendarReducer.self)
struct CalendarView: View {
	@Bindable var store: StoreOf<CalendarReducer>

	var body: some View {
		List {
			permissionsSection
			syncSection
			resetSection
		}
		.listStyle(.insetGrouped)
		.navigationTitle("Calendar")
		.navigationBarTitleDisplayMode(.large)
		.onAppear { send(.onAppear) }
	}
}

// MARK: - Subviews
private extension CalendarView {
	var permissionsSection: some View {
		Section(header: Text("Permissions")) {
			Button {
				send(.onEnableAccessTapped)
			} label: {
				Text(store.isPermissionGranted ? "Access Already Granted" : "Enable Access in Settings")
			}
			.foregroundStyle(store.isPermissionGranted ? Color.gray : Color(.cleethGreen))
			.disabled(store.isPermissionGranted)
		}
	}

	var syncSection: some View {
		Section(header: Text("Sync")) {
			Button {
				send(.onSyncTapped)
			} label: {
				HStack {
					Image(systemName: "calendar")
						.foregroundStyle(Color(.cleethGreen))
					Text("Sync with Calendar")
						.foregroundStyle(Color.primary)
				}
			}
			.confirmationDialog(
				"Do you want to Sync with Calendar?",
				isPresented: Binding(
					get: { store.showSyncDialog },
					set: { _ in send(.onSyncDialogDismissed) }
				),
				titleVisibility: .visible,
				actions: {
					Button("Yes, Sync Now") { send(.onSyncConfirmed) }
						.keyboardShortcut(.defaultAction)
					Button("Cancel", role: .cancel) {}
				},
				message: { Text(Messages.sync) }
			)
		}
	}

	var resetSection: some View {
		Section(header: Text("Reset")) {
			Button {
				send(.onClearTapped)
			} label: {
				HStack {
					Image(systemName: "trash")
					Text("Clear Calendar Events")
				}
			}
			.foregroundColor(.red)
			.confirmationDialog(
				"Are you sure you want to delete all Cleeth Events from your Calendar?",
				isPresented: Binding(
					get: { store.showClearDialog },
					set: { _ in send(.onClearDialogDismissed) }
				),
				titleVisibility: .visible,
				actions: {
					Button("Yes, Delete All", role: .destructive) { send(.onClearConfirmed) }
						.keyboardShortcut(.defaultAction)
					Button("Cancel", role: .cancel) {}
				}
			)
		}
	}
}

// MARK: - Constants
private extension CalendarView {
	enum Messages {
		static let sync =
			"Cleeth will create Events for each time of the day you set to be reminded to Brush your Teeth" +
			" on your Calendar (1 month).\n\nNote: Previous Events set up by Cleeth will be Deleted and" +
			" Replaced with the new configuration."
	}
}

// MARK: - Previews
#Preview {
	NavigationStack {
		CalendarView(store: .init(initialState: .init(), reducer: { CalendarReducer() }))
	}
}
