import SwiftUI

struct TeethStructure: View {
	@EnvironmentObject var brushTimeModel: BrushModel

	var body: some View {
		ZStack {
			ZStack {
				Circle()
					.trim(from: 0.5, to: 1.0)
					.stroke(lineWidth: 30.0)
					.foregroundStyle(Color(.cleethDarkGreen))
					.opacity(0.3)
					.frame(width: 250, height: 500)
					.padding(.bottom, 25)

				Circle()
					.trim(from: 0.5, to: self.brushTimeModel.fillTopTeethBar)
					.stroke(lineWidth: 30.0)
					.foregroundStyle(Color(.cleethGreen))
					.frame(width: 250, height: 500)
					.padding(.bottom, 25)
					.animation(
						self.brushTimeModel.playStopButton
							? Animation.linear(duration: Double(self.brushTimeModel.clockDefaultValue) / 2) : Animation.linear(duration: 0.0),
						value: self.brushTimeModel.playStopButton
					)
			}

			ZStack {
				Circle()
					.trim(from: 0, to: 0.5)
					.stroke(lineWidth: 30.0)
					.foregroundStyle(Color(.cleethDarkGreen))
					.opacity(0.3)
					.frame(width: 250, height: 500)
					.padding(.top, 25)

				Circle()
					.trim(from: 0.0, to: self.brushTimeModel.fillBottomTeethBar)
					.stroke(lineWidth: 30.0)
					.foregroundStyle(Color(.cleethGreen))
					.frame(width: 250, height: 500)
					.padding(.top, 25)
					.animation(
						self.brushTimeModel.playStopButton
							? Animation.linear(duration: Double(self.brushTimeModel.clockDefaultValue) / 2).delay(
								Double(self.brushTimeModel.clockDefaultValue) / 2
							) : Animation.linear(duration: 0.0),
						value: self.brushTimeModel.playStopButton
					)
			}
		}
	}
}

#Preview {
	TeethStructure()
		.environmentObject(BrushModel())
		.environmentObject(NotificationModel())
}
