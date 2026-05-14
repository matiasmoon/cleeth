import Foundation

public class BrushModel: ObservableObject {
	// Create timer for clock
	@Published var timer = Timer()

	// Get values of default and current value for the clock
	@Published var clockDefaultValue = UserDefaults.standard.integer(forKey: "clockDefaultValue")
	@Published var clockCurrentValue = UserDefaults.standard.integer(forKey: "clockCurrentValue")

	// Helpful variables for animation
	@Published var fillTopTeethBar: CGFloat = 0.5
	@Published var fillBottomTeethBar: CGFloat = 0.0

	@Published var playStopButton: Bool = false

	@Published var animatePlay: Bool = false
	@Published var animateStop: Bool = false
	@Published var animateFinish: Bool = false

	@Published var hideTabBar: Bool = false

	/// Restarts the timer of the clock and resets animation-related variables.
	///
	/// This function toggles the state of `playStopButton`, resets the fill levels for the top and bottom teeth bars,
	/// invalidates the current timer, resets the `clockCurrentValue` to `clockDefaultValue`, and toggles the `hideTabBar`.
	///
	func restartClock() {
		self.playStopButton.toggle()

		self.fillTopTeethBar = 0.5
		self.fillBottomTeethBar = 0.0

		self.timer.invalidate()
		self.clockCurrentValue = self.clockDefaultValue

		self.hideTabBar.toggle()
	}

	/// Starts the timer of the clock and sets animation-related variables.
	///
	/// This function toggles the state of `playStopButton`, sets the fill levels for the top and bottom teeth bars,
	/// and toggles the `hideTabBar`.
	///
	func startClock() {
		self.playStopButton.toggle()

		self.fillTopTeethBar = 1.0
		self.fillBottomTeethBar = 0.5

		self.hideTabBar.toggle()
	}

	/// Restarts the timer of the clock and initiates the finish timer animation.
	///
	/// This function calls `restartClock()` to reset the timer and animation variables,
	/// toggles the `hideTabBar`, and schedules a timer to toggle `hideTabBar` after 3 seconds.
	///
	func finishClock() {
		self.restartClock()
		self.hideTabBar.toggle()

		Timer.scheduledTimer(
			withTimeInterval: 3.0,
			repeats: false,
			block: { _ in
				self.hideTabBar.toggle()
			}
		)
	}

	/// This function sets a new default value for the clock
	///
	/// - Parameters:
	///     - new_value: the new default value for the clock
	///
	func setNewValueForClock(new_value: Int) {
		self.clockDefaultValue = new_value
		self.clockCurrentValue = self.clockDefaultValue
		UserDefaults.standard.set(self.clockDefaultValue, forKey: "clockDefaultValue")
		UserDefaults.standard.set(self.clockCurrentValue, forKey: "clockCurrentValue")
	}

	/// Transforms seconds into minutes and remaining seconds.
	///
	/// - Returns: A tuple containing the minutes and remaining seconds.
	///
	func secondsToMinutesSeconds() -> (Int, Int) {
		return ((self.clockCurrentValue % 3600) / 60, (self.clockCurrentValue % 3600) % 60)
	}

	/// Converts the current duration value in seconds to a formatted string representation.
	///
	/// This function retrieves the minutes and seconds components from the current duration value
	/// using the `secondsToMinutesSeconds()` method and formats them into a string using `getMinute(minute:)`
	/// and `getSecond(second:)` methods.
	///
	/// - Returns: A formatted string representing the current duration in "mm:ss" format.
	///
	public func convertDurationToString() -> String {
		let (minute, second) = self.secondsToMinutesSeconds()
		return "\(self.getMinute(minute: minute))\(self.getSecond(second: second))"
	}

	/// Returns a string representation of the given minute value.
	///
	/// - Parameter minute: The minute value to format.
	/// - Returns: A formatted string representing the minute value in "mm:" format.
	///
	private func getMinute(minute: Int) -> String {
		if minute == 0 {
			return "00:"
		}
		if minute < 10 {
			return "0\(minute):"
		}
		return "\(minute):"
	}

	/// Returns a string representation of the given second value.
	///
	/// - Parameter second: The second value to format.
	/// - Returns: A formatted string representing the second value in "ss" format.
	///
	private func getSecond(second: Int) -> String {
		if second == 0 {
			return "00"
		}
		if second < 10 {
			return "0\(second)"
		}
		return "\(second)"
	}
}
