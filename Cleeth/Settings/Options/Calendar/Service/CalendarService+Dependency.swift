import Dependencies

extension CalendarService: DependencyKey {
	static let liveValue: Self = .live
	static let previewValue: Self = .mock
	static let testValue: Self = .test
}

extension DependencyValues {
	var calendarService: CalendarService {
		get { self[CalendarService.self] }
		set { self[CalendarService.self] = newValue }
	}
}
