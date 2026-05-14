import ComposableArchitecture
import SwiftUI

@ViewAction(for: OnboardingReducer.self)
struct OnboardingView: View {
	let store: StoreOf<OnboardingReducer>

	var body: some View {
		TabView {
			ForEach(OnboardingPageModel.defaultContent) {
				OnboardingPageView(model: $0)
			}

			completionPageView
		}
		.tabViewStyle(.page)
	}
}

// MARK: - Subviews
extension OnboardingView {
	private var completionPageView: some View {
		ZStack {
			OnboardingPageView(model: .completion)

			VStack {
				Spacer()

				getStartedButton
					.padding(.bottom, .spacing5XL)
			}
		}
	}

	private var getStartedButton: some View {
		Button {
			send(.onGetStartedTapped)
		} label: {
			ZStack {
				RoundedRectangle(cornerRadius: .cornerRadiusXL)
					.frame(width: .buttonWidth, height: .spacing5XL)
					.foregroundStyle(Color(.cleethGreen))

				Text("onboarding.completion.get_started")
					.foregroundStyle(.white)
					.font(.system(size: .spacingXL))
					.bold()
			}
		}
	}
}

// MARK: - Constants
private extension CGFloat {
	static let buttonWidth: CGFloat = 200
}

// MARK: - Previews
#Preview {
	OnboardingView(
		store: .init(
			initialState: .init(),
			reducer: { OnboardingReducer() }
		)
	)
}
