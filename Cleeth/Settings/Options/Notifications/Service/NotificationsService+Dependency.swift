import Dependencies

extension NotificationsService: DependencyKey {
	static let liveValue: Self = .live
	static let previewValue: Self = .mock
	static let testValue: Self = .test
}

extension DependencyValues {
	var notificationsService: NotificationsService {
		get { self[NotificationsService.self] }
		set { self[NotificationsService.self] = newValue }
	}
}
