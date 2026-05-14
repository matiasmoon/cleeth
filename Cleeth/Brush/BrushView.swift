import SwiftUI

struct BrushView: View {
	@EnvironmentObject var brushViewModel: BrushModel

	var body: some View {
		ZStack {
			BackgroundView()
				.opacity(0.2)
				.ignoresSafeArea()

			VStack {
				Spacer()

				Spacer()

				Text("Cleeth")
					.foregroundStyle(Color(.cleethGreen))
					.font(.system(size: 40.0)).bold()

				Spacer()

				if UIScreen.main.bounds.height < 700 {
					Spacer()
				}

				HStack {
					ClockLabel()
						.padding(.bottom, UIScreen.main.bounds.height < 700 ? -60 : -25)
						.scaleEffect(self.brushViewModel.animatePlay ? 1.0 : 1.1)
						.animation(
							self.brushViewModel.animatePlay ? Animation.easeInOut(duration: 1.0).repeatForever() : Animation.easeOut(duration: 3.0),
							value: self.brushViewModel.animatePlay
						)
				}

				ZStack {
					TeethStructure()
						.scaleEffect(self.brushViewModel.animatePlay ? 1.0 : 1.10)
						.animation(
							self.brushViewModel.animatePlay ? Animation.easeInOut(duration: 1.0).repeatForever() : Animation.easeOut(duration: 3.0),
							value: self.brushViewModel.animatePlay
						)
						.rotationEffect(self.brushViewModel.animateStop ? .degrees(360) : .degrees(0))
						.animation(
							self.brushViewModel.animateStop ? Animation.easeIn(duration: 2.0) : Animation.easeIn(duration: 0.0),
							value: self.brushViewModel.animateStop
						)

					PlayRepeatButtons()
				}
				if UIScreen.main.bounds.height > 700 {
					Spacer()
				}
			}

			ZStack {
				Color(.cleethDarkGreen)
					.opacity(1.0)

				Text("Congrats!")
					.foregroundStyle(Color(.white))
					.font(.system(size: 60.0)).bold()
					.scaleEffect(self.brushViewModel.animateFinish ? 1.0 : 1.30)
					.animation(.bouncy(duration: 1.75), value: self.brushViewModel.animateFinish)
			}
			.opacity(self.brushViewModel.animateFinish ? 0.98 : 0)
		}
		.ignoresSafeArea(.all)
		.toolbar(self.brushViewModel.hideTabBar ? .hidden : .visible, for: .tabBar).animation(.linear(duration: 0.1))
	}
}

#Preview {
	BrushView()
		.environmentObject(BrushModel())
}
