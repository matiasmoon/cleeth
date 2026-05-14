import ComposableArchitecture
import SwiftUI

struct RootView: View {
	@AppStorage("onboardingCompleted") private var onboardingCompleted = false
	@State private var selectedTab = 2
	@State private var onboardingStore = Store(
		initialState: OnboardingReducer.State(),
		reducer: { OnboardingReducer() }
	)

	var body: some View {
		TabView(selection: $selectedTab) {
			BrushView()
				.tabItem { Label("Brush", systemImage: "face.smiling") }
				.tag(2)
			SettingsView()
				.tabItem { Label("Settings", systemImage: "gear") }
				.tag(3)
		}
		.accentColor(Color(.cleethGreen))
		.fullScreenCover(isPresented: showOnboarding) {
			OnboardingView(store: onboardingStore)
				.background(Color(.cleethDarkGreen))
		}
		.onChange(of: onboardingStore.hasCompleted) { _, completed in
			if completed { onboardingCompleted = true }
		}
	}
}

// MARK: - Helpers

private extension RootView {
	var showOnboarding: Binding<Bool> {
		Binding(get: { !onboardingCompleted }, set: { _ in })
	}
}

// MARK: - Previews

#Preview {
	RootView()
		.environmentObject(BrushModel())
}
