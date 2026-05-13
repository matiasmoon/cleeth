import SwiftUI

struct PlayRepeatButtons: View {
	@EnvironmentObject var brushTimeModel: BrushModel

	var body: some View {
		Button(
			action: {
				if brushTimeModel.playStopButton {
					print("Stop Tapped")
					self.brushTimeModel.restartClock()
					self.brushTimeModel.animatePlay.toggle()
					self.brushTimeModel.animateStop.toggle()

					Timer.scheduledTimer(
						withTimeInterval: 2.0,
						repeats: false,
						block: { _ in
							self.brushTimeModel.animateStop.toggle()
						}
					)
				} else {
					print("Play Tapped")
					self.brushTimeModel.startClock()
					self.brushTimeModel.animatePlay.toggle()

					self.brushTimeModel.timer = Timer.scheduledTimer(withTimeInterval: 0.975, repeats: true) { _ in
						self.brushTimeModel.clockCurrentValue -= 1
						if self.brushTimeModel.clockCurrentValue == 0 {
							self.brushTimeModel.finishClock()
							self.brushTimeModel.animatePlay.toggle()
							self.brushTimeModel.animateFinish.toggle()

							Timer.scheduledTimer(
								withTimeInterval: 2.75,
								repeats: false,
								block: { _ in
									self.brushTimeModel.animateFinish.toggle()
								}
							)
						}
					}
				}
			},
			label: {
				Image(systemName: brushTimeModel.playStopButton ? "stop.fill" : "play.fill")
					.animation(.easeInOut(duration: 0.2))
					.font(.system(size: 70.0))
					.foregroundStyle(Color(.cleethGreen))
					.overlay(content: {
						Circle()
							.frame(width: 150, height: 150)
							.foregroundStyle(self.brushTimeModel.animateStop ? Color(.red) : Color(.cleethDarkGreen))
							.opacity(self.brushTimeModel.animateStop ? 1.0 : 0.2)
					})
			}
		)
		.allowsHitTesting(!self.brushTimeModel.animateStop)
	}
}

#Preview {
	PlayRepeatButtons()
		.environmentObject(BrushModel())
		.environmentObject(NotificationModel())
}
