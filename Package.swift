// swift-tools-version: 6.0

import PackageDescription

let package = Package(
	name: "Borderline",
	products: [
		.library(name: "Borderline", targets: ["Borderline"]),
	],
	dependencies: [
		.package(url: "https://github.com/ChimeHQ/Rearrange", branch: "main"),
	],
	targets: [
		.target(name: "Borderline", dependencies: ["Rearrange"]),
		.testTarget(
			name: "BorderlineTests",
			dependencies: ["Borderline"]
		),
	]
)
