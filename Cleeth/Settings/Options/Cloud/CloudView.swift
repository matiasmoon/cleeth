import SwiftUI

struct CloudView: View {
	var body: some View {
		ContentUnavailableView("Coming Soon", systemImage: "icloud")
			.navigationTitle("iCloud")
			.navigationBarTitleDisplayMode(.large)
	}
}

// MARK: - Previews
#Preview {
	NavigationStack {
		CloudView()
	}
}
