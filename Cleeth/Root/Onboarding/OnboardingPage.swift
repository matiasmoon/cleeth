import SwiftUI

// MARK: - View
struct OnboardingPageView: View {
	private let model: OnboardingPageModel

	init(model: OnboardingPageModel) {
		self.model = model
	}

	var body: some View {
		VStack(alignment: .center) {
			VStack(alignment: .center, spacing: .spacingXL) {
				Text(model.title)
					.foregroundStyle(Color(.white))
					.font(.largeTitle)
					.bold()
					.padding(.horizontal, .spacing2XL)

				Text(model.subtitle)
					.foregroundStyle(Color(.white))
					.font(.title2)
					.bold()
					.multilineTextAlignment(.center)
					.padding(.horizontal, .spacing4XL)
			}
			.padding(.top, .titleTopPadding)

			Spacer()

			Image(systemName: model.symbolName)
				.resizable()
				.scaledToFit()
				.foregroundStyle(Color(.cleethGreen))
				.padding(.top, .symbolTopOffset)
				.padding(.horizontal, .symbolHorizontalPadding)

			if let description = model.description {
				Text(description)
					.foregroundStyle(Color(.white))
					.font(.title3)
					.bold()
					.italic()
					.multilineTextAlignment(.center)
					.padding(.top, .spacing4XL)
					.padding(.horizontal, .spacing4XL)
			}

			Spacer()
		}
	}
}

// MARK: - Model
struct OnboardingPageModel: Identifiable {
	let id = UUID()
	let title: LocalizedStringResource
	let subtitle: LocalizedStringResource
	let description: LocalizedStringResource?
	let symbolName: String

	private init(
		title: LocalizedStringResource,
		subtitle: LocalizedStringResource,
		description: LocalizedStringResource? = nil,
		symbolName: String
	) {
		self.title = title
		self.subtitle = subtitle
		self.description = description
		self.symbolName = symbolName
	}
}

// MARK: - Content
extension OnboardingPageModel {
	static let completion: Self = .init(
		title: "onboarding.completion.title",
		subtitle: "onboarding.completion.subtitle",
		symbolName: "checkmark.seal.fill"
	)

	static let defaultContent: [Self] = [
		.init(
			title: "onboarding.goal.title",
			subtitle: "onboarding.goal.subtitle",
			description: "onboarding.goal.description",
			symbolName: "face.smiling"
		),
		.init(
			title: "onboarding.timer.title",
			subtitle: "onboarding.timer.subtitle",
			description: "onboarding.timer.description",
			symbolName: "play.circle.fill"
		),
		.init(
			title: "onboarding.default_timer.title",
			subtitle: "onboarding.default_timer.subtitle",
			description: "onboarding.settings.description",
			symbolName: "timer.circle.fill"
		),
		.init(
			title: "onboarding.notifications.title",
			subtitle: "onboarding.notifications.subtitle",
			description: "onboarding.settings.description",
			symbolName: "bell.badge.fill"
		),
		.init(
			title: "onboarding.calendar.title",
			subtitle: "onboarding.calendar.subtitle",
			description: "onboarding.settings.description",
			symbolName: "calendar.circle.fill"
		),
	]
}

// MARK: - Mock
private extension OnboardingPageModel {
	static let mock: Self = .init(
		title: "Welcome",
		subtitle: "How are you?",
		description: "This is the first page",
		symbolName: "star.fill"
	)
}

// MARK: - Constants
private extension CGFloat {
	static let titleTopPadding: Self = 100
	static let symbolTopOffset: Self = -100
	static let symbolHorizontalPadding: Self = 100
}

// MARK: - Previews
#Preview {
	OnboardingPageView(model: .mock)
}
