import SwiftUI

struct AboutView: View {
	var body: some View {
		ScrollView(.vertical) {
			VStack(alignment: .leading, spacing: .spacingM) {
				appSection

				developerSection

				acknowledgementsSection
			}
			.padding(.horizontal, .spacingM)
			.padding(.bottom, .spacingM)
		}
		.navigationTitle("About")
		.navigationBarTitleDisplayMode(.large)
		.scrollIndicators(.visible, axes: .vertical)
	}
}

// MARK: - Subviews
// swiftlint:disable line_length
extension AboutView {
	private var appSection: some View {
		VStack(alignment: .leading, spacing: .spacingS) {
			Text(" What is Cleeth? 📱")
				.font(.title)
				.bold()

			Text(
				"🪥 Cleeth is an iOS application designed to help everyone (but specially children) in cultivating the habit of brushing their teeth. Cleeth ensures you don't forget to brush by sending notifications and integrating with the Calendar. This by also providing a simple interface and fun animations to accompany you in your journey."
			)
			.font(.body)
		}
	}

	private var developerSection: some View {
		VStack(alignment: .leading, spacing: .spacingS) {
			Text("The Developer 🧑‍💻")
				.font(.title)
				.bold()

			Text(
				"Hi, I'm Matias Ortiz Luna, a 22 years old Computer Engineering Bachelor's graduate and Computer Science Master's student at the Faculty of Sciences of the University of Porto. I was born and raised in Ecuador but have been living in Portugal since 2018.\nI am very passionate about iOS development, Artificial Intelligence, Data Science and Network Science. I identify myself as a proud science nerd, but I'm also a volleyball player, passionate cook, and soon-to-be polyglot. Hoping to one day become Batman; currently, I'm Spiderman.\n\nYou can find me on LinkedIn and GitHub by searching for my full name. I would be happy to connect and exchange insights about any of these topics."
			)
			.font(.body)
		}
	}

	private var acknowledgementsSection: some View {
		VStack(alignment: .leading, spacing: .spacingS) {
			Text("Acknowledgements 🙏")
				.font(.title)
				.bold()

			Text(
				"The idea of creating \"Cleeth\" came to me in February 2023 during a challenging personal moment. To give myself a sense of purpose, I set the goal of publishing my first iOS app during that month. However, during this time and until recently, I took a break from programming to focus on personal growth. Today, I am proud to say that not only do I feel much better about myself, but I have also successfully published my first iOS app on the App Store in November 2023, this one. This achievement reflects my improved well-being and confidence, serving as a reminder that we must prioritize our own well-being so we can excell in our work so we could support others achieve great things to.\n\nFirstly, I want to express my profound gratitude to my extensive family for their unwavering support, love, patience, and care. Their daily dedication and hard work have paved the way for me to achieve my dreams and encounter experiences beyond what I could have imagined. Whether celebrating my successes or guiding me through my mistakes, they have played a pivotal role in shaping the person I am today.\n\nTo my friends who have stood by me through thick and thin, I want to express my heartfelt gratitude. Thank you for patiently listening to all my crazy ideas and providing unwavering support. For encouring me to see life in different ways, but always happy ways. Thanks for all the laughs, smiles, trips, parties, and the deep late-night talks. You are more than friends; you are my second family. A special thanks to Martín, Isabela, Renato, María José, Felipe, José, Inês, Alisson, and Mateo for the impact you've had on me this past year, even if you weren't aware of it.\n\nTo my ex-girlfriend, though we are no longer together, I still cherish the love we shared. Thank you for accepting me for who I am, believing in me, and seeing potential in me that I couldn't see in myself.  I'm eternally grateful for the time we spent together, the cherished memories, the love, the heart-to-heart talks, the confidence, the trust, and the profound connection we shared. I feel fortunate for the wonderful relationship we had, both as friends and as a couple. I genuinely hope that everyone can experience the depth of connection we once had. You're everything that is right in the world, and anyone who has had the privilege of meeting you is truly fortunate. I want to express my gratitude for your patience and empathy, especially over this past year. I wouldn't be in the place I am now if it weren't for you, nor this app. I love you and will always do.\n\nLast but not least, I want to thank me, for believing in me, for putting in all this hard work, for never taking a day off, for never quitting. I want to to thank me for always trying to do the right thing, even when it was the hard thing to do. Thank you for learning from your mistakes, embracing your achievements, accepting yourself, and taking pride in it.\nThank you Matias, for not give up on your dreams, but most importantly, not giving up on yourself during this past year."
			)
			.font(.body)
		}
	}
}

// MARK: - Previews
#Preview {
	AboutView()
}
// swiftlint:enable line_length
