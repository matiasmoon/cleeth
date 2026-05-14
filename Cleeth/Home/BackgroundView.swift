import SwiftUI

struct BackgroundView: View {
	private struct Emoji: Decodable, Hashable, Identifiable {
		var id: Int
		var isSystemName: Bool
		var imageName: String
		var geometry_width: CGFloat = 0.0
		var initial_position: CGFloat = 0.0
	}

	private let emojis: [Emoji] = [
		Emoji(id: 1, isSystemName: false, imageName: "tooth_1f9b7", geometry_width: 0.1, initial_position: 0.0),
		Emoji(id: 2, isSystemName: true, imageName: "bubbles.and.sparkles", geometry_width: 0.1, initial_position: 0.2),
		Emoji(id: 3, isSystemName: false, imageName: "tooth_1f9b7", geometry_width: 0.1, initial_position: 0.4),
		Emoji(id: 4, isSystemName: true, imageName: "bubbles.and.sparkles", geometry_width: 0.1, initial_position: 0.6),
		Emoji(id: 5, isSystemName: false, imageName: "tooth_1f9b7", geometry_width: 0.1, initial_position: 0.8),

		Emoji(id: 6, isSystemName: false, imageName: "toothbrush_1faa5", geometry_width: 0.3, initial_position: 0.1),
		Emoji(id: 7, isSystemName: false, imageName: "toothbrush_1faa5", geometry_width: 0.3, initial_position: 0.3),
		Emoji(id: 8, isSystemName: false, imageName: "toothbrush_1faa5", geometry_width: 0.3, initial_position: 0.5),
		Emoji(id: 9, isSystemName: false, imageName: "toothbrush_1faa5", geometry_width: 0.3, initial_position: 0.7),
		Emoji(id: 10, isSystemName: false, imageName: "toothbrush_1faa5", geometry_width: 0.3, initial_position: 0.9),

		Emoji(id: 21, isSystemName: true, imageName: "bubbles.and.sparkles", geometry_width: 0.5, initial_position: 0.0),
		Emoji(id: 22, isSystemName: true, imageName: "bubbles.and.sparkles", geometry_width: 0.5, initial_position: 0.2),
		Emoji(id: 23, isSystemName: true, imageName: "bubbles.and.sparkles", geometry_width: 0.5, initial_position: 0.4),
		Emoji(id: 24, isSystemName: true, imageName: "bubbles.and.sparkles", geometry_width: 0.5, initial_position: 0.6),
		Emoji(id: 25, isSystemName: true, imageName: "bubbles.and.sparkles", geometry_width: 0.5, initial_position: 0.8),

		Emoji(id: 36, isSystemName: false, imageName: "toothbrush_1faa5", geometry_width: 0.7, initial_position: 0.1),
		Emoji(id: 37, isSystemName: false, imageName: "toothbrush_1faa5", geometry_width: 0.7, initial_position: 0.3),
		Emoji(id: 38, isSystemName: false, imageName: "toothbrush_1faa5", geometry_width: 0.7, initial_position: 0.5),
		Emoji(id: 39, isSystemName: false, imageName: "toothbrush_1faa5", geometry_width: 0.7, initial_position: 0.7),
		Emoji(id: 40, isSystemName: false, imageName: "toothbrush_1faa5", geometry_width: 0.7, initial_position: 0.9),

		Emoji(id: 41, isSystemName: false, imageName: "tooth_1f9b7", geometry_width: 0.9, initial_position: 0.0),
		Emoji(id: 42, isSystemName: true, imageName: "bubbles.and.sparkles", geometry_width: 0.9, initial_position: 0.2),
		Emoji(id: 43, isSystemName: false, imageName: "tooth_1f9b7", geometry_width: 0.9, initial_position: 0.4),
		Emoji(id: 44, isSystemName: true, imageName: "bubbles.and.sparkles", geometry_width: 0.9, initial_position: 0.6),
		Emoji(id: 45, isSystemName: false, imageName: "tooth_1f9b7", geometry_width: 0.9, initial_position: 0.8),
	]

	var body: some View {
		GeometryReader { geometry in
			ForEach(emojis) { emoji in
				EmojiImage(
					isSystemName: emoji.isSystemName,
					imageName: emoji.imageName,
					width: 30,
					height: 30,
					delay: 2.0,
					geometry_width: geometry.size.width * emoji.geometry_width,
					geometry_heigth: geometry.size.height,
					emojiPosition: geometry.size.height * emoji.initial_position
				).environmentObject(BackgroundViewAnimationModel())
			}
		}
	}
}

struct EmojiImage: View {
	@EnvironmentObject var backgroundViewAnimationmodel: BackgroundViewAnimationModel

	var isSystemName: Bool

	var imageName: String
	var width: CGFloat
	var height: CGFloat

	var delay: Float

	var geometry_width: CGFloat
	var geometry_heigth: CGFloat

	@State var emojiPosition: CGFloat
	@State var timer1: Timer?
	@State var timer2: Timer?

	var body: some View {
		Image(isSystemName: isSystemName, imageName: imageName)
			.resizable()
			.frame(width: width, height: height)
			.foregroundStyle(Color(.cleethGreen))
			.symbolEffect(.bounce, options: .repeating, value: backgroundViewAnimationmodel.startAnimation)
			.scaleEffect(backgroundViewAnimationmodel.startAnimation2 ? 1.0 : 1.5)
			.animation(.default, value: backgroundViewAnimationmodel.startAnimation2)
			.onAppear(perform: {
				backgroundViewAnimationmodel.startAnimation2.toggle()
				timer2 = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
					backgroundViewAnimationmodel.startAnimation2.toggle()
				}
			})
			.position(x: geometry_width, y: emojiPosition)
			.onAppear {
				timer1 = Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true) { _ in
					self.emojiPosition -= 1.0
					backgroundViewAnimationmodel.startAnimation.toggle()
					if self.emojiPosition < 0 {
						self.emojiPosition = geometry_heigth
					}
				}
			}
	}
}

class BackgroundViewAnimationModel: ObservableObject {
	@Published var startAnimation: Bool = false
	@Published var startAnimation2: Bool = false
}

extension Image {
	init(isSystemName: Bool, imageName: String) {
		if isSystemName {
			self = Image(systemName: imageName)
		} else {
			self = Image(imageName)
		}
	}
}

#Preview {
	BackgroundView()
		.environmentObject(BrushModel())
}
