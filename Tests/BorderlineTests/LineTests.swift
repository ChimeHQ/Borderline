import Foundation
import Testing

import Borderline

@Suite
struct LineTests {
	@Test
	func rangeFromComponents() {
		let line = Line<Int>(
			index: 0,
			start: 0,
			lengths: LineComponentLengths(leadingWhitespace: 2, content: 10, trailingWhitespace: 1, ending: 2)
		)

		#expect(line.range(of: .leadingWhitespace) == NSRange(0..<2))
		#expect(line.range(of: .content) == NSRange(2..<12))
		#expect(line.range(of: .trailingWhitespace) == NSRange(12..<13))
		#expect(line.range(of: .ending) == NSRange(13..<15))
	}
}
