import ComposableArchitecture
import SwiftUI
import UserNotifications

@main
struct CleethApp: App {
    let store = Store(initialState: AppReducer.State()) { AppReducer() }

    @Environment(\.scenePhase) private var scenePhase

    init() {
        UserDefaults.standard.register(
            defaults: [
                "clockDefaultValue": 180,
                "clockCurrentValue": 180,
                "timesPerDay": 2,
                "date1": Calendar.current.date(
                    bySettingHour: 10,
                    minute: 0,
                    second: 0,
                    of: Date()
                )!,
                "date2": Calendar.current.date(
                    bySettingHour: 20,
                    minute: 0,
                    second: 0,
                    of: Date()
                )!,
                "date3": Date(),
                "date4": Date(),
                "date5": Date(),
                "date6": Date(),
                "notificationsProvided": false,
            ]
        )
    }

    var body: some Scene {
        WindowGroup {
            RootView(store: store)
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                UNUserNotificationCenter.current().setBadgeCount(0)
            }
        }
    }
}
