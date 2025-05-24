import Foundation

extension NSString {
	func firstLocation(from set: CharacterSet, in range: NSRange) -> Int? {
		let loc = rangeOfCharacter(from: set, range: range).location
		
		return loc == NSNotFound ? nil : loc
	}
}

public struct UTF16CodePointLineParser: Sendable {
	public typealias LineType = Line<Int>

	private let nonWhitespaceCharacterSet = CharacterSet.whitespacesAndNewlines.inverted
	
	public init() {
	}

	public func parseLines(in string: String, indexOffset: Int, locationOffset: Int, includeLastLine: Bool) -> [LineType] {
		if string.isEmpty {
			return [
				LineType(
					index: indexOffset,
					start: locationOffset,
					lengths: .empty
				)
			]
		}
		
		let nsString = string as NSString

		var start = 0
		var end = 0
		var terminatorStart = 0

		var lines: [LineType] = []

		while end < nsString.length {
			nsString.getLineStart(&start, end: &end, contentsEnd: &terminatorStart, for: NSRange(start..<end))

			let contentStart = nsString.firstLocation(from: nonWhitespaceCharacterSet, in: NSRange(start..<terminatorStart)) ?? terminatorStart
			let contentEnd = nsString.firstLocation(from: .whitespaces, in: NSRange(contentStart..<terminatorStart)) ?? terminatorStart
						
			let lengths = LineComponentLengths(
				leadingWhitespace: contentStart - start,
				content: contentEnd - contentStart,
				trailingWhitespace: terminatorStart - contentEnd,
				ending: end - terminatorStart
			)

			let index = lines.count + indexOffset

			let line = LineType(index: index, start: start + locationOffset, lengths: lengths)

			lines.append(line)
			start = end
		}

		if includeLastLine == false {
			return lines
		}
		
		if let endingChar = string.last, endingChar.isNewline {
			let endingLength = endingChar.unicodeScalars.count
			
			let lastLine = LineType(
				index: lines.count + indexOffset,
				start: start + locationOffset,
				lengths: LineComponentLengths(leadingWhitespace: 0, content: 0, trailingWhitespace: 0, ending: endingLength)
			)
			
			lines.append(lastLine)

		}
		
		return lines
	}
}
