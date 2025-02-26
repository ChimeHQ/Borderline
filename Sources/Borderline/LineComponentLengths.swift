import Foundation

import Rearrange

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
	case range
}

public struct LineComponentLengths: Hashable, Sendable {
	public let leadingWhitespace: Int
	public let content: Int
	public let trailingWhitespace: Int
	public let ending: Int

	public init(leadingWhitespace: Int, content: Int, trailingWhitespace: Int, ending: Int) {
		self.leadingWhitespace = leadingWhitespace
		self.content = content
		self.trailingWhitespace = trailingWhitespace
		self.ending = ending
	}

	public var total: Int {
		leadingWhitespace + content + trailingWhitespace + ending
	}

	public func range<Calculator: TextRangeCalculating>(
		of component: LineComponent,
		from position: Calculator.Position,
		with calculator: Calculator
	) -> Calculator.TextRange? {
		switch component {
		case .leadingWhitespace:
			guard let end = calculator.position(from: position, offset: leadingWhitespace) else {
				return nil
			}

			return calculator.textRange(from: position, to: end)
		case .trailingWhitespace:
			guard
				let start = calculator.position(from: position, offset: leadingWhitespace + content),
				let end = calculator.position(from: start, offset: trailingWhitespace)
			else {
				return nil
			}

			return calculator.textRange(from: start, to: end)
		case .content:
			guard
				let start = calculator.position(from: position, offset: leadingWhitespace),
				let end = calculator.position(from: start, offset: content)
			else {
				return nil
			}

			return calculator.textRange(from: start, to: end)
		case .ending:
			guard
				let start = calculator.position(from: position, offset: leadingWhitespace + content + trailingWhitespace),
				let end = calculator.position(from: start, offset: content)
			else {
				return nil
			}

			return calculator.textRange(from: start, to: end)
		case .range:
			guard
				let start = calculator.position(from: position, offset: total),
				let end = calculator.position(from: start, offset: content)
			else {
				return nil
			}

			return calculator.textRange(from: start, to: end)
		}
	}

	public func range(of component: LineComponent, from position: Int) -> NSRange {
		switch component {
		case .leadingWhitespace:
			NSRange(location: position, length: leadingWhitespace)
		case .trailingWhitespace:
			NSRange(location: position + leadingWhitespace + content, length: trailingWhitespace)
		case .content:
			NSRange(location: position + leadingWhitespace, length: content)
		case .ending:
			NSRange(location: position + leadingWhitespace + content + trailingWhitespace, length: ending)
		case .range:
			NSRange(location: position, length: total)
		}
	}
}
