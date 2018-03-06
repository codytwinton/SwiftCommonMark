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
		NodeParser(regex: "^ {0,3}(#{1,6})(?:[ \t]+|$)(.*)", templates: ["$1", "$2"]) {
			let level: HeadingLevel = HeadingLevel(rawValue: $0[0].count) ?? .h1
			return .heading(level: level, nodes: parseNodes(markdown: $0[1]))
		},
		NodeParser(regex: "(\\_{2}|\\*{2})(.+)(\\_{2}|\\*{2})", templates: ["$2"]) {
			return .strong(nodes: parseNodes(markdown: $0[0]))
		},
		NodeParser(regex: "(\\_|\\*)([^\\_\\*]+)(\\_|\\*)", templates: ["$2"]) {
			return .emphasis(nodes: parseNodes(markdown: $0[0]))
		}
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
		return .document(nodes: nodes)
	}

	static func parseNodes(markdown: String) -> [CommonMarkNode] {

		var nodes: [CommonMarkNode] = []

		var input = markdown

		while !input.isEmpty {
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

			switch input.first == "\n" {
			case true:
				let index = input.index(input.startIndex, offsetBy: 1)
				nodes.append(.text(String(input[..<index])))
				input = String(input[index...])
			case false:
				nodes.append(.text(input))
				input = ""
			}
		}

		return nodes
	}
}
