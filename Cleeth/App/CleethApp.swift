import SwiftUI

@main
struct CleethApp: App {
	// Initiate State (Global) objects
	@StateObject var brushTimeModel = BrushModel()

	@Environment(\.scenePhase) private var scenePhase

	init() {
		// Set default values for variables in case they have not been initiated before
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
			// Create main view, and include models as environment objects
			ContentView()
				.environmentObject(brushTimeModel)
				.onAppear(perform: {
					// When app's opened, always check if the app has Notification Permissions
					//					Helper.requestNotificationsPermission()
				})
		}
		.onChange(of: scenePhase) { phase in
			// IDK what's this
			if phase == .active {
				UNUserNotificationCenter.current().setBadgeCount(0)
			}
		}
	}
}
