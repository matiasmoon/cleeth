import SwiftUI

struct TermsOfUseView: View {
	var body: some View {
		ContentUnavailableView("Coming Soon", systemImage: "doc.text")
			.navigationTitle("Terms of Use")
			.navigationBarTitleDisplayMode(.large)
	}
}

// MARK: - Previews
#Preview {
	NavigationStack {
		TermsOfUseView()
	}
}
