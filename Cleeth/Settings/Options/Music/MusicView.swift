import SwiftUI

struct MusicView: View {
	var body: some View {
		ContentUnavailableView("Coming Soon", systemImage: "music.note")
			.navigationTitle("Music")
			.navigationBarTitleDisplayMode(.large)
	}
}

// MARK: - Previews
#Preview {
	NavigationStack {
		MusicView()
	}
}
