/// The components that make up the anatomy of a line of text.
///
/// For a left-to-right language, the conponets are:
///
///     [leading][content][trailing][ending]
///
///
/// A line that consists only of whitespace is defined as leading.
///
///     [leading][ending]
public enum LineComponent: Hashable, Sendable {
	/// the range of whitespace that appears before the content
	case leadingWhitespace
	/// The range of whitespace that appears after the content.
	///
	/// The line ending characters are **not** part of trailing whitespace.
	case trailingWhitespace
	/// the range of non-whitespace within the line
	case content
	/// The line terminator characters.
	case ending
	/// the entire range of the line, including both whitespace and content
	case fullSpan
}

/// Calculate positions and ranges of text using the semantics of the content.
public protocol TextMetricTokenizer<Location> {
	associatedtype Location: Comparable

	func lineComponentStart(_ component: LineComponent, for location: Location) -> Location?
	func lineComponentEnd(_ component: LineComponent, for location: Location) -> Location?
}

extension TextMetricTokenizer where Location: Comparable {
	public func lineComponentRange(_ component: LineComponent, for location: Location) -> Range<Location>? {
		guard
			let start = lineComponentStart(component, for: location),
			let end = lineComponentEnd(component, for: location)
		else {
			return nil
		}

		return start..<end
	}
}
