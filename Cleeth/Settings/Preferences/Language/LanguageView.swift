import SwiftUI

struct LanguageView: View {
	var body: some View {
		ContentUnavailableView("Coming Soon", systemImage: "globe")
			.navigationTitle("Language")
			.navigationBarTitleDisplayMode(.large)
	}
}

// MARK: - Previews
#Preview {
	NavigationStack {
		LanguageView()
	}
}
