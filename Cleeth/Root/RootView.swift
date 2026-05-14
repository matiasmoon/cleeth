import ComposableArchitecture
import SwiftUI

@ViewAction(for: AppReducer.self)
struct RootView: View {
    let store: StoreOf<AppReducer>

    var body: some View {
        TabView(selection: Binding(
            get: { store.selectedTab },
            set: { send(.onTabSelected($0)) }
        )) {
            BrushView(store: store.scope(state: \.home, action: \.home))
                .tabItem { Label("Brush", systemImage: "face.smiling") }
                .tag(2)
            SettingsView(store: store.scope(state: \.home, action: \.home))
                .tabItem { Label("Settings", systemImage: "gear") }
                .tag(3)
        }
        .accentColor(Color(.cleethGreen))
        .fullScreenCover(isPresented: showOnboarding) {
            OnboardingView(store: store.scope(state: \.onboarding, action: \.onboarding))
                .background(Color(.cleethDarkGreen))
        }
    }
}

// MARK: - Helpers

private extension RootView {
    var showOnboarding: Binding<Bool> {
        Binding(get: { !store.onboardingCompleted }, set: { _ in })
    }
}

// MARK: - Previews

#Preview {
    RootView(
        store: .init(
            initialState: .init(),
            reducer: { AppReducer() }
        )
    )
}
