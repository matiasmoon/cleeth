import ComposableArchitecture
import Foundation
import UIKit

@Reducer
struct NotificationsReducer {
	@Dependency(\.notificationsService) private var notificationsService

	// MARK: - State
	@ObservableState
	struct State: Equatable {
		var isPermissionGranted: Bool
		var timesPerDay: Int
		var dates: [Date]

		init(
			isPermissionGranted: Bool = false,
			timesPerDay: Int = 2,
			dates: [Date] = Array(repeating: Calendar.current.date(from: DateComponents(hour: 8)) ?? .now, count: 6)
		) {
			self.isPermissionGranted = isPermissionGranted
			self.timesPerDay = timesPerDay
			self.dates = dates
		}
	}

	// MARK: - Actions
	enum Action: ViewAction, Equatable {
		enum ViewAction: Equatable {
			case onAppear
			case onDisappear
			case onEnableNotificationsTapped
			case onTimesPerDayChanged(Int)
			case onDateChanged(index: Int, date: Date)
		}

		enum InternalAction: Equatable {
			case loaded(timesPerDay: Int, dates: [Date], isPermissionGranted: Bool)
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

// MARK: - ViewAction
private extension NotificationsReducer {
	func viewActions(_ action: Action.ViewAction, state: inout State) -> Effect<Action> {
		switch action {
		case .onAppear:
			return .run(
				operation: { send in
					async let permission = notificationsService.checkPermission()
					let saved = notificationsService.load()

					await send(
						.internal(
							.loaded(
								timesPerDay: saved.timesPerDay,
								dates: saved.dates,
								isPermissionGranted: await permission
							)
						)
					)
				},
				catch: { _, _ in
					// TODO: Implement error handling
				}
			)

		case .onDisappear:
			let dates = state.dates
			let timesPerDay = state.timesPerDay
			return .run { _ in
				await notificationsService.scheduleNotifications(dates, timesPerDay)
			}

		case .onEnableNotificationsTapped:
			return .run { _ in
				guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
				await MainActor.run { UIApplication.shared.open(url) }
			}

		case .onTimesPerDayChanged(let newValue):
			state.timesPerDay = newValue
			state.dates = (1...6).map { slot in
				Calendar.current.date(from: DateComponents(hour: defaultHour(timesPerDay: newValue, slot: slot))) ?? .now
			}
			return .none

		case .onDateChanged(let index, let date):
			state.dates[index] = date
			return .none
		}
	}
}

// MARK: - InternalAction
private extension NotificationsReducer {
	func internalActions(_ action: Action.InternalAction, state: inout State) -> Effect<Action> {
		switch action {
		case .loaded(let timesPerDay, let dates, let isPermissionGranted):
			state.timesPerDay = timesPerDay
			state.dates = dates
			state.isPermissionGranted = isPermissionGranted
			return .none
		}
	}
}

// MARK: - Helpers
private extension NotificationsReducer {
	func defaultHour(timesPerDay: Int, slot: Int) -> Int {
		switch (timesPerDay, slot) {
		case (2, 1): 8
		case (2, 2): 23
		case (3, 1): 8
		case (3, 2): 14
		case (3, 3): 23
		case (4, 1): 8
		case (4, 2): 14
		case (4, 3): 17
		case (4, 4): 23
		case (5, 1): 8
		case (5, 2): 11
		case (5, 3): 14
		case (5, 4): 17
		case (5, 5): 23
		case (6, 1): 8
		case (6, 2): 11
		case (6, 3): 14
		case (6, 4): 17
		case (6, 5): 20
		case (6, 6): 23
		default: 8
		}
	}
}
