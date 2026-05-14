import ComposableArchitecture
import Foundation

@Reducer
struct HomeReducer {
    @ObservableState
    struct State: Equatable {
        var defaultDuration: Int = UserDefaults.standard.integer(forKey: "clockDefaultValue")
        var remainingTime: Int = UserDefaults.standard.integer(forKey: "clockCurrentValue")
        var topArcProgress: CGFloat = 0.5
        var bottomArcProgress: CGFloat = 0.0
        var isPlaying: Bool = false
        var isAnimatingBrush: Bool = false
        var isAnimatingStop: Bool = false
        var isShowingCompletion: Bool = false
        var isTabBarHidden: Bool = false

        var timeString: String {
            let minutes = (remainingTime % 3600) / 60
            let seconds = (remainingTime % 3600) % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }

    enum Action: ViewAction, Equatable {
        enum ViewAction: Equatable {
            case onPlayTapped
            case onStopTapped
            case onDurationChanged(Int)
        }

        enum InternalAction: Equatable {
            case timerTick
            case stopAnimationCompleted
            case finishAnimationCompleted
            case tabBarHideCompleted
        }

        case view(ViewAction)
        case `internal`(InternalAction)
    }

    private enum CancelID {
        case timer
        case stopAnimation
        case finishAnimation
        case tabBarHide
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(let action): return handleViewAction(state: &state, action: action)
            case .internal(let action): return handleInternalAction(state: &state, action: action)
            }
        }
    }
}

// MARK: - View Action Handler

private extension HomeReducer {
    func handleViewAction(state: inout State, action: Action.ViewAction) -> Effect<Action> {
        switch action {
        case .onPlayTapped:
            state.isPlaying = true
            state.topArcProgress = 1.0
            state.bottomArcProgress = 0.5
            state.isTabBarHidden = true
            state.isAnimatingBrush = true
            return .run { send in
                while true {
                    try await Task.sleep(for: .milliseconds(975))
                    await send(.internal(.timerTick))
                }
            }
            .cancellable(id: CancelID.timer, cancelInFlight: true)

        case .onStopTapped:
            state.isPlaying = false
            state.topArcProgress = 0.5
            state.bottomArcProgress = 0.0
            state.remainingTime = state.defaultDuration
            state.isTabBarHidden = false
            state.isAnimatingBrush = false
            state.isAnimatingStop = true
            return .concatenate(
                .cancel(id: CancelID.timer),
                .run { send in
                    try await Task.sleep(for: .seconds(2))
                    await send(.internal(.stopAnimationCompleted))
                }
                .cancellable(id: CancelID.stopAnimation, cancelInFlight: true)
            )

        case .onDurationChanged(let seconds):
            state.defaultDuration = seconds
            state.remainingTime = seconds
            UserDefaults.standard.set(seconds, forKey: "clockDefaultValue")
            UserDefaults.standard.set(seconds, forKey: "clockCurrentValue")
            return .none
        }
    }
}

// MARK: - Internal Action Handler

private extension HomeReducer {
    func handleInternalAction(state: inout State, action: Action.InternalAction) -> Effect<Action> {
        switch action {
        case .timerTick:
            state.remainingTime -= 1
            guard state.remainingTime == 0 else { return .none }
            state.isPlaying = false
            state.topArcProgress = 0.5
            state.bottomArcProgress = 0.0
            state.remainingTime = state.defaultDuration
            state.isAnimatingBrush = false
            state.isShowingCompletion = true
            state.isTabBarHidden = true
            return .concatenate(
                .cancel(id: CancelID.timer),
                .merge(
                    .run { send in
                        try await Task.sleep(for: .seconds(3))
                        await send(.internal(.tabBarHideCompleted))
                    }
                    .cancellable(id: CancelID.tabBarHide, cancelInFlight: true),
                    .run { send in
                        try await Task.sleep(for: .milliseconds(2750))
                        await send(.internal(.finishAnimationCompleted))
                    }
                    .cancellable(id: CancelID.finishAnimation, cancelInFlight: true)
                )
            )

        case .stopAnimationCompleted:
            state.isAnimatingStop = false
            return .none

        case .finishAnimationCompleted:
            state.isShowingCompletion = false
            return .none

        case .tabBarHideCompleted:
            state.isTabBarHidden = false
            return .none
        }
    }
}
