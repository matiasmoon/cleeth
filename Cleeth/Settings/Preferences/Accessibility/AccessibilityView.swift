import SwiftUI

struct AccessibilityView: View {
	var body: some View {
		ContentUnavailableView("Coming Soon", systemImage: "accessibility")
			.navigationTitle("Accessibility")
			.navigationBarTitleDisplayMode(.large)
	}
}

// MARK: - Previews
#Preview {
	NavigationStack {
		AccessibilityView()
	}
}
