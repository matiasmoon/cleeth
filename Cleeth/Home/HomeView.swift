import ComposableArchitecture
import SwiftUI

@ViewAction(for: HomeReducer.self)
struct HomeView: View {
    let store: StoreOf<HomeReducer>

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
                    .font(.system(size: .titleFontSize)).bold()

                Spacer()

                if UIScreen.main.bounds.height < .compactScreenHeight {
                    Spacer()
                }

                timerLabel
                    .padding(.bottom, UIScreen.main.bounds.height < .compactScreenHeight ? .clockPaddingCompact : .clockPaddingRegular)
                    .scaleEffect(store.isAnimatingBrush ? 1.0 : 1.1)
                    .animation(
                        store.isAnimatingBrush ? Animation.easeInOut(duration: 1.0).repeatForever() : Animation.easeOut(duration: 3.0),
                        value: store.isAnimatingBrush
                    )

                ZStack {
                    TeethStructure(store: store)
                        .scaleEffect(store.isAnimatingBrush ? 1.0 : 1.10)
                        .animation(
                            store.isAnimatingBrush ? Animation.easeInOut(duration: 1.0).repeatForever() : Animation.easeOut(duration: 3.0),
                            value: store.isAnimatingBrush
                        )
                        .rotationEffect(store.isAnimatingStop ? .degrees(360) : .degrees(0))
                        .animation(
                            store.isAnimatingStop ? Animation.easeIn(duration: 2.0) : Animation.easeIn(duration: .zero),
                            value: store.isAnimatingStop
                        )

                    brushTimerButton
                }

                if UIScreen.main.bounds.height > .compactScreenHeight {
                    Spacer()
                }
            }

            completionOverlay
        }
        .ignoresSafeArea(.all)
        .toolbar(store.isTabBarHidden ? .hidden : .visible, for: .tabBar)
        .animation(.linear(duration: 0.1), value: store.isTabBarHidden)
    }
}

// MARK: - Subviews

private extension HomeView {
    var timerLabel: some View {
        Text(store.timeString)
            .animation(.easeIn(duration: 0.2))
            .foregroundStyle(Color(.cleethGreen))
            .font(.system(size: .timerFontSize)).bold()
            .overlay {
                RoundedRectangle(cornerSize: CGSize(width: .timerCornerRadius, height: .timerCornerRadius))
                    .frame(width: .timerOverlayWidth, height: .timerOverlayHeight)
                    .foregroundStyle(Color(.cleethDarkGreen))
                    .opacity(0.2)
            }
    }

    var brushTimerButton: some View {
        Button {
            send(store.isPlaying ? .onStopTapped : .onPlayTapped)
        } label: {
            Image(systemName: store.isPlaying ? "stop.fill" : "play.fill")
                .animation(.easeInOut(duration: 0.2))
                .font(.system(size: .buttonIconSize))
                .foregroundStyle(Color(.cleethGreen))
                .overlay {
                    Circle()
                        .frame(width: .buttonCircleSize, height: .buttonCircleSize)
                        .foregroundStyle(store.isAnimatingStop ? Color(.red) : Color(.cleethDarkGreen))
                        .opacity(store.isAnimatingStop ? 1.0 : 0.2)
                }
        }
        .allowsHitTesting(!store.isAnimatingStop)
    }

    var completionOverlay: some View {
        ZStack {
            Color(.cleethDarkGreen)
            Text("Congrats!")
                .foregroundStyle(Color(.white))
                .font(.system(size: .congratsFontSize)).bold()
                .scaleEffect(store.isShowingCompletion ? 1.0 : 1.30)
                .animation(.bouncy(duration: 1.75), value: store.isShowingCompletion)
        }
        .opacity(store.isShowingCompletion ? 0.98 : 0)
    }
}

// MARK: - Constants

private extension CGFloat {
    static let titleFontSize: CGFloat = 40
    static let timerFontSize: CGFloat = 60
    static let congratsFontSize: CGFloat = 60
    static let compactScreenHeight: CGFloat = 700
    static let clockPaddingCompact: CGFloat = -60
    static let clockPaddingRegular: CGFloat = -25
    static let timerCornerRadius: CGFloat = 20
    static let timerOverlayWidth: CGFloat = 200
    static let timerOverlayHeight: CGFloat = 100
    static let buttonIconSize: CGFloat = 70
    static let buttonCircleSize: CGFloat = 150
}

// MARK: - Previews

#Preview {
    HomeView(
        store: .init(
            initialState: .init(),
            reducer: { HomeReducer() }
        )
    )
}
