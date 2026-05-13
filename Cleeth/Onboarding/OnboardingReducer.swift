import ComposableArchitecture

@Reducer
struct OnboardingReducer {
    @ObservableState
    struct State: Equatable {
        var hasCompleted = false
    }

    enum Action: ViewAction, Equatable {
        enum ViewAction: Equatable {
            case onGetStartedTapped
        }

        case view(ViewAction)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onGetStartedTapped):
                state.hasCompleted = true
                return .none
            }
        }
    }
}
