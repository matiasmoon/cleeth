import SwiftUI
import UIKit

struct BackgroundView: View {
    private struct EmojiConfig: Identifiable {
        let id: Int
        let isSystemName: Bool
        let imageName: String
        let xFraction: CGFloat
        let initialYFraction: CGFloat
        let phaseOffset: Double
    }

    private let configs: [EmojiConfig] = [
        .init(id:  1, isSystemName: false, imageName: "tooth_1f9b7",          xFraction: 0.1, initialYFraction: 0.0, phaseOffset: 0.0),
        .init(id:  2, isSystemName: true,  imageName: "bubbles.and.sparkles", xFraction: 0.1, initialYFraction: 0.2, phaseOffset: 0.7),
        .init(id:  3, isSystemName: false, imageName: "tooth_1f9b7",          xFraction: 0.1, initialYFraction: 0.4, phaseOffset: 1.4),
        .init(id:  4, isSystemName: true,  imageName: "bubbles.and.sparkles", xFraction: 0.1, initialYFraction: 0.6, phaseOffset: 2.1),
        .init(id:  5, isSystemName: false, imageName: "tooth_1f9b7",          xFraction: 0.1, initialYFraction: 0.8, phaseOffset: 2.8),
        .init(id:  6, isSystemName: false, imageName: "toothbrush_1faa5",     xFraction: 0.3, initialYFraction: 0.1, phaseOffset: 0.3),
        .init(id:  7, isSystemName: false, imageName: "toothbrush_1faa5",     xFraction: 0.3, initialYFraction: 0.3, phaseOffset: 1.0),
        .init(id:  8, isSystemName: false, imageName: "toothbrush_1faa5",     xFraction: 0.3, initialYFraction: 0.5, phaseOffset: 1.7),
        .init(id:  9, isSystemName: false, imageName: "toothbrush_1faa5",     xFraction: 0.3, initialYFraction: 0.7, phaseOffset: 2.4),
        .init(id: 10, isSystemName: false, imageName: "toothbrush_1faa5",     xFraction: 0.3, initialYFraction: 0.9, phaseOffset: 3.1),
        .init(id: 11, isSystemName: true,  imageName: "bubbles.and.sparkles", xFraction: 0.5, initialYFraction: 0.0, phaseOffset: 0.5),
        .init(id: 12, isSystemName: true,  imageName: "bubbles.and.sparkles", xFraction: 0.5, initialYFraction: 0.2, phaseOffset: 1.2),
        .init(id: 13, isSystemName: true,  imageName: "bubbles.and.sparkles", xFraction: 0.5, initialYFraction: 0.4, phaseOffset: 1.9),
        .init(id: 14, isSystemName: true,  imageName: "bubbles.and.sparkles", xFraction: 0.5, initialYFraction: 0.6, phaseOffset: 2.6),
        .init(id: 15, isSystemName: true,  imageName: "bubbles.and.sparkles", xFraction: 0.5, initialYFraction: 0.8, phaseOffset: 3.3),
        .init(id: 16, isSystemName: false, imageName: "toothbrush_1faa5",     xFraction: 0.7, initialYFraction: 0.1, phaseOffset: 0.1),
        .init(id: 17, isSystemName: false, imageName: "toothbrush_1faa5",     xFraction: 0.7, initialYFraction: 0.3, phaseOffset: 0.8),
        .init(id: 18, isSystemName: false, imageName: "toothbrush_1faa5",     xFraction: 0.7, initialYFraction: 0.5, phaseOffset: 1.5),
        .init(id: 19, isSystemName: false, imageName: "toothbrush_1faa5",     xFraction: 0.7, initialYFraction: 0.7, phaseOffset: 2.2),
        .init(id: 20, isSystemName: false, imageName: "toothbrush_1faa5",     xFraction: 0.7, initialYFraction: 0.9, phaseOffset: 2.9),
        .init(id: 21, isSystemName: false, imageName: "tooth_1f9b7",          xFraction: 0.9, initialYFraction: 0.0, phaseOffset: 0.4),
        .init(id: 22, isSystemName: true,  imageName: "bubbles.and.sparkles", xFraction: 0.9, initialYFraction: 0.2, phaseOffset: 1.1),
        .init(id: 23, isSystemName: false, imageName: "tooth_1f9b7",          xFraction: 0.9, initialYFraction: 0.4, phaseOffset: 1.8),
        .init(id: 24, isSystemName: true,  imageName: "bubbles.and.sparkles", xFraction: 0.9, initialYFraction: 0.6, phaseOffset: 2.5),
        .init(id: 25, isSystemName: false, imageName: "tooth_1f9b7",          xFraction: 0.9, initialYFraction: 0.8, phaseOffset: 3.2),
    ]

    var body: some View {
        GeometryReader { geometry in
            TimelineView(.animation(minimumInterval: .animationInterval)) { context in
                let elapsed = context.date.timeIntervalSinceReferenceDate
                ZStack {
                    ForEach(configs) { config in
                        emojiView(config, elapsed: elapsed, size: geometry.size)
                    }
                }
            }
        }
    }
}

// MARK: - Helpers

private extension BackgroundView {
    private func emojiView(_ config: EmojiConfig, elapsed: Double, size: CGSize) -> some View {
        let period = size.height > 0 ? Double(size.height) / Double(CGFloat.scrollSpeed) : 1.0
        let phase = elapsed.truncatingRemainder(dividingBy: period)
        let startY = size.height * config.initialYFraction
        let rawY = startY - CGFloat(phase) * .scrollSpeed
        let yValue = rawY < 0 ? rawY + size.height : rawY
        let scale = 1.0 + .scaleAmplitude * CGFloat(sin(elapsed * Double(CGFloat.scaleFrequency) + config.phaseOffset))

        return Image(isSystemName: config.isSystemName, imageName: config.imageName)
            .resizable()
            .frame(width: .iconSize, height: .iconSize)
            .foregroundStyle(Color(UIColor.cleethGreen))
            .scaleEffect(scale)
            .position(x: size.width * config.xFraction, y: yValue)
    }
}

// MARK: - Constants

private extension CGFloat {
    static let iconSize: CGFloat = 30
    static let scrollSpeed: CGFloat = 15
    static let scaleAmplitude: CGFloat = 0.15
    static let scaleFrequency: CGFloat = 1.5
}

private extension TimeInterval {
    static let animationInterval: TimeInterval = 1.0 / 30.0
}

// MARK: - Image Extension

extension Image {
    init(isSystemName: Bool, imageName: String) {
        if isSystemName {
            self = Image(systemName: imageName)
        } else {
            self = Image(imageName)
        }
    }
}

// MARK: - Previews

#Preview {
    BackgroundView()
}
