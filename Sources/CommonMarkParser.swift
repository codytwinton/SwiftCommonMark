//
//  CommonMarkParser.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/4/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

import Foundation

enum CommonMarkOutput {
	case html
}

// MARK: -

struct CommonMarkParser {

	// MARK: Variables

	var node: CommonMarkNode

	init(markdown: String) {
		node = CommonMarkParser.parse(markdown: markdown)
	}

	func render(to output: CommonMarkOutput = .html) -> String {
		return node.html
	}

	static func parse(markdown: String) -> CommonMarkNode {
		let nodes = parseNodes(markdown: markdown)
		return .document(nodes: nodes)
	}

	static func parseNodes(markdown: String) -> [CommonMarkNode] {
		var nodes: [CommonMarkNode] = []

		for value in markdown.components(separatedBy: .newlines) {
			guard let regex = try? NSRegularExpression(pattern: "^\\#{1,6}\\s?([^#\n]+)\\s??\\#*", options: .anchorsMatchLines) else {
				nodes.append(.text(value))
				continue
			}

			guard let match = regex.firstMatch(in: value, options: .withoutAnchoringBounds, range: NSRange(location: 0, length: value.count)) else {
				nodes.append(.text(value))
				continue
			}

			guard match.range.location != NSNotFound else {
				nodes.append(.text(value))
				continue
			}

			guard let level = HeadingLevel(rawValue: match.range(at: 1).location - 1) else {
				nodes.append(.text(value))
				continue
			}

			print("level \(level)")

			let start = value.index(value.startIndex, offsetBy: match.range(at: 1).location)
			let remaining = String(value[start...])

			let headingNodes = parseNodes(markdown: remaining)
			nodes.append(.heading(level: level, nodes: headingNodes))
		}

		return nodes
	}
}
