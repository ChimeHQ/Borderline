import Foundation

import Rearrange

public struct Line<TextPosition> {
	public let index: Int
	public let lowerBound: TextPosition
	public let lengths: LineComponentLengths

	public init(index: Int, start: TextPosition, lengths: LineComponentLengths) {
		self.index = index
		self.lowerBound = start
		self.lengths = lengths
	}
	
	public var isWhitespaceOnly: Bool {
		lengths.content == 0
	}
}

extension Line: Equatable where TextPosition: Equatable {}
extension Line: Hashable where TextPosition: Hashable {}
extension Line: Sendable where TextPosition: Sendable {}

extension Line {
	public var length: Int {
		lengths.total
	}

	public func range<Calculator: TextRangeCalculating>(
		of component: LineComponent,
		with calculator: Calculator
	) -> Calculator.TextRange? where TextPosition == Calculator.Position {
		lengths.range(of: component, from: lowerBound, with: calculator)
	}
}

extension Line where TextPosition == Int {
	public func range(of component: LineComponent) -> NSRange {
		lengths.range(of: component, from: lowerBound)
	}

	public var upperBound: Int {
		lowerBound + length
	}
}
