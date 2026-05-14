import SwiftUI

struct PrivacyPolicyView: View {
	var body: some View {
		ScrollView(.vertical) {
			VStack(alignment: .leading, spacing: .spacingM) {
				introSection

				noteSection

				dataSection
			}
			.padding(.horizontal, .spacingM)
			.padding(.bottom, .spacingM)
		}
		.navigationTitle("Privacy Policy")
		.navigationBarTitleDisplayMode(.large)
		.scrollIndicators(.visible, axes: .vertical)
	}
}

// MARK: - Subviews
// swiftlint:disable line_length
extension PrivacyPolicyView {
	private var introSection: some View {
		VStack(alignment: .leading, spacing: .spacingS) {
			Text("Last updated: November 2023")
				.italic()
				.font(.body)

			Text("Matias Ortiz Luna is the sole operator of the Cleeth iOS mobile application, available on the App Store.")
				.font(.body)

			Text(
				"This document outlines the policies on the collection, use, and disclosure of personal data when utilizing the Cleeth App and the choices available to users."
			)
			.font(.body)
		}
	}

	private var noteSection: some View {
		VStack(alignment: .leading, spacing: .spacingS) {
			Text("Note from the Author and Developer:")
				.font(.title3)
				.bold()

			Text(
				"As a graduate with a Bachelor's degree in Computer Engineering and currently pursuing a Master's in Computer Science, I understand the importance and risks associated with data. The Cleeth app was designed to function without requiring any user information. No data is collected, connected, or shared with external entities. Information related to the app's proper functioning remains exclusively on your device. For inquiries, please contact me at matiasortizluna.contacto@gmail.com."
			)
			.font(.body)
		}
	}

	private var dataSection: some View {
		VStack(alignment: .leading, spacing: .spacingM) {
			Text("Data & Information Collection and Use")
				.font(.title2)
				.bold()

			ForEach(PolicySection.content) { section in
				VStack(alignment: .leading, spacing: .spacingS) {
					Text(section.title)
						.font(.headline)
						.bold()

					if let note = section.note {
						Text(note)
							.font(.subheadline)
							.italic()
					}

					Text(section.body)
						.font(.body)
				}
			}
		}
	}
}

// MARK: - Content
private struct PolicySection: Identifiable {
	var id: String { title }
	let title: String
	let body: String
	var note: String?

	static let content: [PolicySection] = [
		.init(
			title: "Data & Information Types Collection Policy:",
			body:
				"For Cleeth app usage, no data, especially personally identifiable information, is collected to contact or identify users. The only information that is stored locally is the device's settings for:\n\n- The Time for each Brush\n- The Number of Notifications to be sent.\n- The Time for sending those notifications.\n\nThis information will be referred to as \"Device's Brushing Preferences for the correct functionality of the Cleeth App.\"",
			note:
				"Note: Personal Data & Personally identifiable information include: Email address, First Name and Last Name, Phone Number, Address, State, Province, ZIP/Postal Code, City, Cookies, and Usage Data."
		),
		.init(
			title: "Data & Information Collection Policy:",
			body:
				"Device's Brushing Preferences for the correct functionality of the Cleeth App are stored locally when modifying default settings in the app's options. This information never leaves your device."
		),
		.init(
			title: "Data & Information Usage Policy:",
			body:
				"Device's Brushing Preferences for the correct functionality of the Cleeth App are stored locally and used to save personal preferences, ensuring the best user experience. This includes setting the brush time, the number of notifications, and the notification times."
		),
		.init(
			title: "Data & Information Revoke Consent Policy:",
			body:
				"As the app does not collect information, and the Device's Brushing Preferences for the correct functionality of the Cleeth App are stored locally and never leave your device, consent can be revoked by deleting the app, removing all information, including your Device's Brushing Preferences."
		),
		.init(
			title: "Data & Information Retention Policy:",
			body:
				"Device's Brushing Preferences for the correct functionality of the Cleeth App remain on your device only as long as you use the app. Deleting the app removes all associated information."
		),
		.init(
			title: "Data & Information Deletion Policy:",
			body:
				"As the app does not collect information, and the Device's Brushing Preferences for the correct functionality of the Cleeth App are stored locally and never leave your device, you can delete any information by removing the app, including your Device's Brushing Preferences."
		),
		.init(
			title: "Data & Information Access Policy:",
			body:
				"Nobody, including the author and developer, has access to your Device's Brushing Preferences for the correct functionality of the Cleeth App."
		),
		.init(
			title: "Data & Information Security:",
			body:
				"The app was developed with robust security measures to protect your Device's Brushing Preferences for the correct functionality of the Cleeth App."
		),
		.init(
			title: "Data & Information of Children Policy:",
			body:
				"The app is intended for individuals aged 4 and older. Due to the absence of data collection, children are not at risk of data sharing. Concerned parents or guardians can contact us for necessary actions or delete the app immediately."
		),
		.init(
			title: "Data & Information Policy Changes:",
			body:
				"While Policy Changes are expected to be minor, the Cleeth App reserves the right to make modifications to its Privacy Policy at its sole discretion. Users' continued use of the app following any updates to the Privacy Policy implies their acceptance of such changes."
		),
		.init(
			title: "Data & Information Collection, Usage, Selling, or Sharing to Third Parties:",
			body:
				"Cleeth does not collect any data or Device's Brushing Preferences for the correct functionality of the Cleeth App, stored locally and never leaving the device. Therefore, nothing is sold or shared with third parties."
		),
		.init(
			title: "User Rights and Consent:",
			body:
				"By using the Cleeth App, users consent to the local storage of their Device's Brushing Preferences for the correct functionality of the Cleeth App for the duration of app usage."
		),
		.init(
			title: "Indemnity:",
			body:
				"The user hereby indemnifies Cleeth App, its developer, and the author of the Privacy Policy, Matias Ortiz Luna, undertaking to keep them indemnified against any losses, damages, costs, liabilities, and expenses incurred or suffered by the user arising from the use of this app or any breach by the user of any provision of these terms of use. This indemnity also extends to cover any claims asserting that the user has breached any provision of these terms of use."
		),
		.init(
			title: "Contact Information:",
			body: "For any questions about this Privacy Policy, contact its author and the Cleeth App developer at matiasortizluna.contacto@gmail.com."
		),
	]
}
// swiftlint:enable line_length

// MARK: - Previews
#Preview {
	PrivacyPolicyView()
}
