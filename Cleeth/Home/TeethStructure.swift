import ComposableArchitecture
import SwiftUI

struct TeethStructure: View {
    let store: StoreOf<HomeReducer>

    var body: some View {
        ZStack {
            topArc
            bottomArc
        }
    }
}

// MARK: - Subviews

private extension TeethStructure {
    var topArc: some View {
        ZStack {
            Circle()
                .trim(from: 0.5, to: 1.0)
                .stroke(lineWidth: .strokeWidth)
                .foregroundStyle(Color(.cleethDarkGreen))
                .opacity(0.3)
                .frame(width: .circleSize, height: .circleHeight)
                .padding(.bottom, .arcPadding)

            Circle()
                .trim(from: 0.5, to: store.topArcProgress)
                .stroke(lineWidth: .strokeWidth)
                .foregroundStyle(Color(.cleethGreen))
                .frame(width: .circleSize, height: .circleHeight)
                .padding(.bottom, .arcPadding)
                .animation(
                    store.isPlaying
                        ? Animation.linear(duration: Double(store.defaultDuration) / 2)
                        : Animation.linear(duration: .zero),
                    value: store.isPlaying
                )
        }
    }

    var bottomArc: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 0.5)
                .stroke(lineWidth: .strokeWidth)
                .foregroundStyle(Color(.cleethDarkGreen))
                .opacity(0.3)
                .frame(width: .circleSize, height: .circleHeight)
                .padding(.top, .arcPadding)

            Circle()
                .trim(from: 0.0, to: store.bottomArcProgress)
                .stroke(lineWidth: .strokeWidth)
                .foregroundStyle(Color(.cleethGreen))
                .frame(width: .circleSize, height: .circleHeight)
                .padding(.top, .arcPadding)
                .animation(
                    store.isPlaying
                        ? Animation.linear(duration: Double(store.defaultDuration) / 2)
                            .delay(Double(store.defaultDuration) / 2)
                        : Animation.linear(duration: .zero),
                    value: store.isPlaying
                )
        }
    }
}

// MARK: - Constants

private extension CGFloat {
    static let strokeWidth: CGFloat = 30
    static let circleSize: CGFloat = 250
    static let circleHeight: CGFloat = 500
    static let arcPadding: CGFloat = 25
}

// MARK: - Previews

#Preview {
    TeethStructure(
        store: .init(
            initialState: .init(),
            reducer: { HomeReducer() }
        )
    )
}
