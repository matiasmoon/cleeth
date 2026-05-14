import ComposableArchitecture

@Reducer
struct OnboardingReducer {
    @ObservableState
    struct State: Equatable {}

    enum Action: ViewAction, Equatable {
        enum ViewAction: Equatable {
            case onGetStartedTapped
        }

        enum DelegateAction: Equatable {
            case completed
        }

        case view(ViewAction)
        case delegate(DelegateAction)
    }

    var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .view(.onGetStartedTapped):
                return .send(.delegate(.completed))
            case .delegate:
                return .none
            }
        }
    }
}
