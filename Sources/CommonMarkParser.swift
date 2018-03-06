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

struct NodeParser {
	let type: CommonMarkNodeType
	let generator: ([String]) -> CommonMarkNode
}

// MARK: -

struct CommonMarkParser {

	// MARK: - Constants

	static let parsers: [NodeParser] = [
		NodeParser(type: .heading) {
			let level: HeadingLevel = HeadingLevel(rawValue: $0[0].count) ?? .h1
			let raw = $0[1]
			var components = raw.components(separatedBy: " #")

			if let last = components.last?.trimmingCharacters(in: .whitespaces) {
				let set = Set(last)
				if set.count == 1, set.first == "#" {
					components.removeLast()
				}
			}

			let markdown = components.joined(separator: " #").replacingOccurrences(of: "\\#", with: "#")
			return .heading(level: level, nodes: parseNodes(markdown: markdown))
		},
		NodeParser(type: .strong) {
			return .strong(nodes: parseNodes(markdown: $0[0]))
		},
		NodeParser(type: .emphasis) {
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

		guard !markdown.isEmpty else {
			nodes.append(.text(markdown))
			return nodes
		}

		var input = markdown

		while !input.isEmpty {

			var isMatched = false

			for parser in parsers {
				guard let regexMatch = input.match(regex: parser.type.regex, with: parser.type.regexTemplates) else { continue }
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
