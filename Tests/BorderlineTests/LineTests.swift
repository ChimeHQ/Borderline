import Foundation
import Testing
import Borderline

@Suite
struct LineTests {
	@Test
	func rangeFromBeginning() {
		let line = Line(index: 5, range: NSRange(location: 10, length: 10))

		let range = line.rangeFromBeginning(to: 14)

		#expect(range == NSRange(location: 10, length: 4))
	}

	@Test
	func rangeToEnd() {
		let line = Line(index: 5, range: NSRange(location: 10, length: 10))

		let range = line.rangeToEnd(from: 14)

		#expect(range == NSRange(location: 14, length: 6))
	}
}
