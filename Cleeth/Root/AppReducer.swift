import ComposableArchitecture
import Foundation

@Reducer
struct AppReducer {
    @ObservableState
    struct State: Equatable {
        var selectedTab: Int = 2
        var onboardingCompleted: Bool = UserDefaults.standard.bool(forKey: "onboardingCompleted")
        var onboarding: OnboardingReducer.State = .init()
        var home: HomeReducer.State = .init()
    }

    enum Action: ViewAction, Equatable {
        enum ViewAction: Equatable {
            case onTabSelected(Int)
        }

        case view(ViewAction)
        case onboarding(OnboardingReducer.Action)
        case home(HomeReducer.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.onboarding, action: \.onboarding) { OnboardingReducer() }
        Scope(state: \.home, action: \.home) { HomeReducer() }

        Reduce { state, action in
            switch action {
            case .view(.onTabSelected(let tab)):
                state.selectedTab = tab
                return .none

            case .onboarding(.delegate(.completed)):
                state.onboardingCompleted = true
                UserDefaults.standard.set(true, forKey: "onboardingCompleted")
                return .none

            case .onboarding, .home:
                return .none
            }
        }
    }
}
