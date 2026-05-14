import ComposableArchitecture
import Foundation
import UIKit

@Reducer
struct CalendarReducer {
	@Dependency(\.calendarService) private var calendarService

	// MARK: - State
	@ObservableState
	struct State: Equatable {
		var isPermissionGranted = false
		var showSyncDialog = false
		var showClearDialog = false
	}

	// MARK: - Actions
	enum Action: ViewAction, Equatable {
		enum ViewAction: Equatable {
			case onAppear
			case onEnableAccessTapped
			case onSyncTapped
			case onSyncConfirmed
			case onSyncDialogDismissed
			case onClearTapped
			case onClearConfirmed
			case onClearDialogDismissed
		}

		enum InternalAction: Equatable {
			case permissionLoaded(Bool)
		}

		enum DelegateAction: Equatable {}

		case view(ViewAction)
		case `internal`(InternalAction)
		case delegate(DelegateAction)
	}

	// MARK: - Body
	var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .view(let action): viewActions(action, state: &state)
			case .internal(let action): internalActions(action, state: &state)
			case .delegate: .none
			}
		}
	}
}

// MARK: - ViewActions
private extension CalendarReducer {
	func viewActions(_ action: Action.ViewAction, state: inout State) -> Effect<Action> {
		switch action {
		case .onAppear:
			return .run { send in
				await send(.internal(.permissionLoaded(calendarService.checkPermission())))
			}

		case .onEnableAccessTapped:
			return .run { _ in
				guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
				await MainActor.run { UIApplication.shared.open(url) }
			}

		case .onSyncTapped:
			state.showSyncDialog = true
			return .run { _ in await calendarService.requestAccess() }

		case .onSyncConfirmed:
			state.showSyncDialog = false
			return .run { _ in await calendarService.sync() }

		case .onSyncDialogDismissed:
			state.showSyncDialog = false
			return .none

		case .onClearTapped:
			state.showClearDialog = true
			return .none

		case .onClearConfirmed:
			state.showClearDialog = false
			return .run { _ in await calendarService.clear() }

		case .onClearDialogDismissed:
			state.showClearDialog = false
			return .none
		}
	}
}

// MARK: - InternalActions
private extension CalendarReducer {
	func internalActions(_ action: Action.InternalAction, state: inout State) -> Effect<Action> {
		switch action {
		case .permissionLoaded(let granted):
			state.isPermissionGranted = granted
			return .none
		}
	}
}
