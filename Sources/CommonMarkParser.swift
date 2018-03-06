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

struct NodeParser {
	let regex: String
	let templates: [String]
	let generator: ([String]) -> CommonMarkNode
}

struct CommonMarkParser {

	// MARK: - Constants

	static let parsers: [NodeParser] = [
		NodeParser(regex: "^(\\#{1,6}\\s?)([^#\n]+)\\s??\\#*", templates: ["$1", "$2"]) {
			let level: HeadingLevel = HeadingLevel(rawValue: Int($0[0]) ?? 0) ?? .h1
			return .heading(level: level, nodes: parseNodes(markdown: $0[1]))
		}/*,
		NodeParser(regex: "([^\\s]+)", templates: ["$1"]) {
			return CommonMarkNode.text($0[0])
		}*/
	]

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
		print("nodes \(nodes)")
		return .document(nodes: nodes)
	}

	static func parseNodes(markdown: String) -> [CommonMarkNode] {

		var nodes: [CommonMarkNode] = []

		var input = markdown

		while !input.isEmpty {
			print("input \(input)")

			var isMatched = false

			for parser in parsers {
				guard let regexMatch = input.match(regex: parser.regex, with: parser.templates) else { continue }
				let result = parser.generator(regexMatch.captures)
				nodes.append(result)

				let inputOffset = input.index(input.startIndex, offsetBy: regexMatch.fullMatch.count)
				input = String(input[inputOffset...])
				isMatched = true
				break
			}

			guard !isMatched else { continue }
			nodes.append(.text(input))
			input = ""
			break
			/*
			let index = input.index(input.startIndex, offsetBy: 1)
			nodes.append(.text(String(input[..<index])))
			input = String(input[index...])
			*/
		}

		return nodes
	}
}
