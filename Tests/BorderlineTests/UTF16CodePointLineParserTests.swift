import Foundation
import Testing

import Borderline

@Suite
struct StringLineParserTests {
	@Test
	func emptyString() {
		let lines = UTF16CodePointLineParser().parseLines(in: "", indexOffset: 0, locationOffset: 0)

		let expected = [
			Line<Int>(index: 0, start: 0, lengths: .init(leadingWhitespace: 0, content: 0, trailingWhitespace: 0, ending: 0))
		]

		#expect(lines == expected)
	}

	@Test
	func singleLine() {
		let lines = UTF16CodePointLineParser().parseLines(in: "abc", indexOffset: 0, locationOffset: 0)

		let expected = [
			Line<Int>(index: 0, start: 0, lengths: .init(leadingWhitespace: 0, content: 3, trailingWhitespace: 0, ending: 0))
		]

		#expect(lines == expected)
	}

	@Test
	func singleLineWithLF() {
		let lines = UTF16CodePointLineParser().parseLines(in: "abc\n", indexOffset: 0, locationOffset: 0)

		let expected = [
			Line<Int>(index: 0, start: 0, lengths: .init(leadingWhitespace: 0, content: 3, trailingWhitespace: 0, ending: 1))
		]

		#expect(lines == expected)
	}

	@Test
	func singleLineWithCRLF() {
		let lines = UTF16CodePointLineParser().parseLines(in: "abc\r\n", indexOffset: 0, locationOffset: 0)

		let expected = [
			Line<Int>(index: 0, start: 0, lengths: .init(leadingWhitespace: 0, content: 3, trailingWhitespace: 0, ending: 2))
		]

		#expect(lines == expected)
	}

	@Test
	func twoLines() {
		let lines = UTF16CodePointLineParser().parseLines(in: "abc\ndef", indexOffset: 0, locationOffset: 0)

		let expected = [
			Line<Int>(index: 0, start: 0, lengths: .init(leadingWhitespace: 0, content: 3, trailingWhitespace: 0, ending: 1)),
			Line<Int>(index: 1, start: 4, lengths: .init(leadingWhitespace: 0, content: 3, trailingWhitespace: 0, ending: 0)),
		]

		#expect(lines == expected)
	}
}
