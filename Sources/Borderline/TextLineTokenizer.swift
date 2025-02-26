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
