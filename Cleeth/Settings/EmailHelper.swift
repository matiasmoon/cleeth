import Foundation
import MessageUI

class EmailHelper: NSObject, MFMailComposeViewControllerDelegate {
	public static let shared = EmailHelper()

	/// Sends an email.
	///
	/// - Parameters:
	///   - subject: The subject of the email.
	///   - body: The body of the email.
	///   - to: The recipient of the email.
	///   - completion: A completion handler that takes a boolean indicating if the email can be sent.
	///
	func sendEmail(subject: String, body: String, toRecipients: String, completion: @escaping (Bool) -> Void) {
		if MFMailComposeViewController.canSendMail() {
			let picker = MFMailComposeViewController()
			picker.setSubject(subject)
			picker.setMessageBody(body, isHTML: true)
			picker.setToRecipients([toRecipients])
			picker.mailComposeDelegate = self

			UIApplication.shared.windows.first?.rootViewController?.present(picker, animated: true, completion: nil)
		}
		completion(MFMailComposeViewController.canSendMail())
	}

	/// Dismisses the mail compose view controller.
	///
	/// - Parameters:
	///   - controller: The MFMailComposeViewController instance.
	///   - result: The result of the email composition.
	///   - error: An optional error that occurred during composition.
	///
	internal func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		controller.dismiss(animated: true, completion: nil)
	}
}
