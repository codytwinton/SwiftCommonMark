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
		let nodes = CommonMarkNode.parseNodes(markdown: markdown)
		self.node = .document(nodes: nodes)
	}

	func render(to output: CommonMarkOutput = .html) -> String {
		return node.html
	}
}

extension CommonMarkNode {

	static func parseNodes(markdown: String) -> [CommonMarkNode] {
		var nodes: [CommonMarkNode] = []

		for value in markdown.components(separatedBy: .newlines) {
			guard let regex = try? NSRegularExpression(pattern: "^#{1,6}(?:[ \t]+|$)", options: []) else {
				nodes.append(.text(value))
				continue
			}

			let range = regex.rangeOfFirstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count))

			if range.location == NSNotFound {
				nodes.append(.text(value))
				continue
			}

			guard let level = HeadingLevel(rawValue: range.length - 1) else {
				nodes.append(.text(value))
				continue
			}

			let start = value.index(value.startIndex, offsetBy: range.location + range.length)
			let remaining = String(value[start...])

			let headingNodes = parseNodes(markdown: remaining)
			nodes.append(.heading(level: level, nodes: headingNodes))
		}

		return nodes
	}

	var regex: String {
		switch self {
		case .heading:
			return "^#{1,6}(?:[ \t]+|$)"
		case .code, .codeBlock, .htmlBlock, .htmlInline, .lineBreak, .softBreak,
			 .text, .thematicBreak, .document, .blockQuote, .list, .item, .paragraph,
			 .emphasis, .strong, .link, .image, .customInline, .customBlock:
			return ""
		}
	}
}
