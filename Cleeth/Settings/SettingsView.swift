import ComposableArchitecture
import StoreKit
import SwiftUI

@ViewAction(for: HomeReducer.self)
struct SettingsView: View {
    let store: StoreOf<HomeReducer>
    @Environment(\.requestReview) private var requestReview
    @Environment(\.openURL) private var openURL

    var body: some View {
        NavigationStack {
            List {
                timeSection

                optionsSection

                accessibilitySection

                supportSection

                legalSection

                versionSection
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Subviews

private extension SettingsView {
    var timeSection: some View {
        Section(header: Text("Time for Every Brush")) {
            Picker("Time", systemImage: "timer", selection: Binding(
                get: { store.defaultDuration / 60 },
                set: { send(.onDurationChanged($0 * 60)) }
            )) {
                ForEach(2..<11, id: \.self) { Text("\($0) minutes") }
            }
        }
    }

    var optionsSection: some View {
        Section(header: Text("Options")) {
            NavigationLink(
                destination: NotificationsView(
                    store: .init(initialState: .init(), reducer: { NotificationsReducer() })
                )
            ) {
                HStack {
                    Image(systemName: "bell.badge")
                        .foregroundStyle(Color(.cleethGreen))
                    Text("Notifications")
                }
            }

            NavigationLink(
                destination: CalendarView(
                    store: .init(initialState: .init(), reducer: { CalendarReducer() })
                )
            ) {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundStyle(Color(.cleethGreen))
                    Text("Calendar")
                }
            }

            NavigationLink(
                destination: RemindersView(
                    store: .init(initialState: .init(), reducer: { RemindersReducer() })
                )
            ) {
                HStack {
                    Image(systemName: "list.bullet.clipboard")
                        .foregroundStyle(Color(.cleethGreen))
                    Text("Reminders")
                }
            }

            NavigationLink(destination: MusicView()) {
                HStack {
                    Image(systemName: "music.note")
                        .foregroundStyle(Color(.cleethGreen))
                    Text("Music")
                }
            }

            NavigationLink(destination: CloudView()) {
                HStack {
                    Image(systemName: "icloud")
                        .foregroundStyle(Color(.cleethGreen))
                    Text("iCloud")
                }
            }
        }
    }

    var accessibilitySection: some View {
        Section(header: Text("Preferences")) {
            NavigationLink(destination: AccessibilityView()) {
                HStack {
                    Image(systemName: "accessibility")
                        .foregroundStyle(Color(.cleethGreen))
                    Text("Accessibility")
                }
            }

            NavigationLink(destination: LanguageView()) {
                HStack {
                    Image(systemName: "globe")
                        .foregroundStyle(Color(.cleethGreen))
                    Text("Language")
                }
            }
        }
    }

    var supportSection: some View {
        Section(header: Text("Support")) {
            HStack {
                ShareLink(
                    items: [URL(string: "https://apps.apple.com/tr/app/cleeth/id6472682824")!],
                    subject: Text("Download Cleeth Now!"),
                    message: Text("Hey! Check out this app that helps you remember to brush your teeth!"),
                    label: {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundStyle(Color(.cleethGreen))
                            Text("Share")
                                .foregroundStyle(Color.primary)
                        }
                    }
                )
            }

            HStack {
                Button {
                    requestReview()
                } label: {
                    HStack {
                        Image(systemName: "star")
                            .foregroundStyle(Color(.cleethGreen))
                        Text("Evaluate")
                    }
                }
                .foregroundStyle(Color.primary)
            }

            HStack {
                Button {
                    openURL(feedbackMailURL)
                } label: {
                    HStack {
                        Image(systemName: "envelope.badge")
                            .foregroundStyle(Color(.cleethGreen))
                        Text("Feedback & Support")
                            .foregroundStyle(Color.primary)
                    }
                }
            }
        }
    }

    var legalSection: some View {
        Section(header: Text("Legal")) {
            NavigationLink(destination: AboutView()) {
                HStack {
                    Image(systemName: "info.circle")
                        .foregroundStyle(Color(.cleethGreen))
                    Text("About")
                }
                .foregroundStyle(Color.primary)
            }

            NavigationLink(destination: PrivacyPolicyView()) {
                HStack {
                    Image(systemName: "hand.raised")
                        .foregroundStyle(Color(.cleethGreen))
                    Text("Privacy Policy")
                }
                .foregroundStyle(Color.primary)
            }

            NavigationLink(destination: TermsOfUseView()) {
                HStack {
                    Image(systemName: "doc.text")
                        .foregroundStyle(Color(.cleethGreen))
                    Text("Terms of Use")
                }
                .foregroundStyle(Color.primary)
            }
        }
    }

    var versionSection: some View {
        Text("Version 1.2")
            .font(.footnote)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .center)
            .listRowBackground(Color.clear)
    }
}

// MARK: - Constants

private extension SettingsView {
    var feedbackMailURL: URL {
        URL(string: "mailto:matiasortizluna.contacto@gmail.com?subject=Inquiry%20about%20Cleeth%20%F0%9F%AA%A5")!
    }
}

// MARK: - Previews

#Preview {
    SettingsView(
        store: .init(
            initialState: .init(),
            reducer: { HomeReducer() }
        )
    )
}
