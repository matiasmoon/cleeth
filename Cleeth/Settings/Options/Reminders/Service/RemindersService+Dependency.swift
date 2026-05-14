import Dependencies

extension RemindersService: DependencyKey {
	static let liveValue: Self = .live
	static let previewValue: Self = .mock
	static let testValue: Self = .test
}

extension DependencyValues {
	var remindersService: RemindersService {
		get { self[RemindersService.self] }
		set { self[RemindersService.self] = newValue }
	}
}
