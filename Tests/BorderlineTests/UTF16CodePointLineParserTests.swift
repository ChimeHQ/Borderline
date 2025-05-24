import Foundation
import Testing

import Borderline

struct StringLineParserTests {
	@Test func emptyString() {
		let lines = UTF16CodePointLineParser().parseLines(in: "", indexOffset: 0, locationOffset: 0, includeLastLine: false)

		let expected = [
			Line<Int>(index: 0, start: 0, lengths: .init(leadingWhitespace: 0, content: 0, trailingWhitespace: 0, ending: 0))
		]

		#expect(lines == expected)
	}

	@Test func singleLine() {
		let lines = UTF16CodePointLineParser().parseLines(in: "abc", indexOffset: 0, locationOffset: 0, includeLastLine: false)

		let expected = [
			Line<Int>(index: 0, start: 0, lengths: .init(leadingWhitespace: 0, content: 3, trailingWhitespace: 0, ending: 0))
		]

		#expect(lines == expected)
	}

	@Test func singleLineWithLF() {
		let lines = UTF16CodePointLineParser().parseLines(in: "abc\n", indexOffset: 0, locationOffset: 0, includeLastLine: false)

		let expected = [
			Line<Int>(index: 0, start: 0, lengths: .init(leadingWhitespace: 0, content: 3, trailingWhitespace: 0, ending: 1))
		]

		#expect(lines == expected)
	}

	@Test func singleLineWithCRLF() {
		let lines = UTF16CodePointLineParser().parseLines(in: "abc\r\n", indexOffset: 0, locationOffset: 0, includeLastLine: false)

		let expected = [
			Line<Int>(index: 0, start: 0, lengths: .init(leadingWhitespace: 0, content: 3, trailingWhitespace: 0, ending: 2))
		]

		#expect(lines == expected)
	}

	@Test func twoLines() {
		let lines = UTF16CodePointLineParser().parseLines(in: "abc\ndef", indexOffset: 0, locationOffset: 0, includeLastLine: false)

		let expected = [
			Line<Int>(index: 0, start: 0, lengths: .init(leadingWhitespace: 0, content: 3, trailingWhitespace: 0, ending: 1)),
			Line<Int>(index: 1, start: 4, lengths: .init(leadingWhitespace: 0, content: 3, trailingWhitespace: 0, ending: 0)),
		]

		#expect(lines == expected)
	}
	
	@Test func singleTab() {
		let lines = UTF16CodePointLineParser().parseLines(in: "\t", indexOffset: 0, locationOffset: 0, includeLastLine: false)

		let expected = [
			Line<Int>(index: 0, start: 0, lengths: .init(leadingWhitespace: 1, content: 0, trailingWhitespace: 0, ending: 0)),
		]

		#expect(lines == expected)
	}
	
	@Test func leadingAndTrailingSpaces() {
		let lines = UTF16CodePointLineParser().parseLines(in: " a ", indexOffset: 0, locationOffset: 0, includeLastLine: false)

		let expected = [
			Line<Int>(index: 0, start: 0, lengths: .init(leadingWhitespace: 1, content: 1, trailingWhitespace: 1, ending: 0)),
		]

		#expect(lines == expected)
	}

	@Test func leadingAndTrailingSpacesWithWhitespaceWithinContent() {
		let lines = UTF16CodePointLineParser().parseLines(in: " a b c ", indexOffset: 0, locationOffset: 0, includeLastLine: false)

		let expected = [
			Line<Int>(index: 0, start: 0, lengths: .init(leadingWhitespace: 1, content: 5, trailingWhitespace: 1, ending: 0)),
		]

		#expect(lines == expected)
	}

	@Test func whitespaceWithinContent() {
		let lines = UTF16CodePointLineParser().parseLines(in: "a b c", indexOffset: 0, locationOffset: 0, includeLastLine: false)

		let expected = [
			Line<Int>(index: 0, start: 0, lengths: .init(leadingWhitespace: 0, content: 5, trailingWhitespace: 0, ending: 0)),
		]

		#expect(lines == expected)
	}
}
