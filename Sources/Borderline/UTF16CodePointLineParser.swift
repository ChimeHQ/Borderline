import Foundation

public struct UTF16CodePointLineParser: Sendable {
	public typealias LineType = Line<Int>

	private let nonWhitespaceCharacterSet = CharacterSet.whitespacesAndNewlines.inverted
	
	public init() {
	}

	public func parseLines(in string: String, indexOffset: Int, locationOffset: Int) -> [LineType] {
		if string.isEmpty {
			return [
				LineType(
					index: indexOffset,
					start: locationOffset,
					lengths: .init(leadingWhitespace: 0, content: 0, trailingWhitespace: 0, ending: 0)
				)
			]
		}
		
		let string = string as NSString

		var start = 0
		var end = 0
		var contentsEnd = 0

		var lines: [LineType] = []

		while end < string.length {
			string.getLineStart(&start, end: &end, contentsEnd: &contentsEnd, for: NSRange(start..<end))

			let lengths = LineComponentLengths(
				leadingWhitespace: 0,
				content: contentsEnd - start,
				trailingWhitespace: 0,
				ending: end - contentsEnd
			)

			let index = lines.count + indexOffset

			let line = LineType(index: index, start: start + locationOffset, lengths: lengths)

			lines.append(line)
			start = end
		}

		return lines
	}
}
