//
//  CommonMarkParser.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/4/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

import Foundation

struct NodeParser {
	let type: NodeType
	let generator: ([String]) -> Node
}

// MARK: -

struct CommonMarkParser {

	// MARK: - Constants

	static let parsers: [NodeParser] = [
		NodeParser(type: .thematicBreak) { _ in
			return .thematicBreak
		},
		NodeParser(type: .heading) { matches in
			let level: HeadingLevel = HeadingLevel(rawValue: matches[0].count) ?? .h1
			let raw = matches[1]
			var components = raw.components(separatedBy: " #")

			if let last = components.last?.trimmingCharacters(in: .whitespaces) {
				let set = Set(last)
				if set.count == 1, set.first == "#" {
					components.removeLast()
				}
			}

			let markdown = components.joined(separator: " #").replacingOccurrences(of: "\\#", with: "#")
			return .heading(level: level, nodes: parseNodes(markdown: markdown, in: .heading))
		},
		NodeParser(type: .strong) { matches in
			return .strong(nodes: parseNodes(markdown: matches[0], in: .strong))
		},
		NodeParser(type: .emphasis) { matches in
			return .emphasis(nodes: parseNodes(markdown: matches[0], in: .emphasis))
		}
	]

	// MARK: Variables

	var node: Node

	init(markdown: String) {
		node = CommonMarkParser.parse(markdown: markdown)
	}

	func render() -> String {
		return node.html
	}

	static func parse(markdown: String) -> Node {
		let nodes = parseNodes(markdown: markdown, in: .document)
		return .document(nodes: nodes)
	}

	static func parseNodes(markdown: String, in type: NodeType) -> [Node] {

		var nodes: [Node] = []

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

			guard !isMatched, let first = input.first else { continue }

			if first == "\n" {
				let index = input.index(input.startIndex, offsetBy: 1)
				nodes.append(.text(String(first)))
				input = String(input[index...])
			} else if type == .document, let paragraphIndex = input.index(of: "\n") {
				let paragraph = String(input[..<paragraphIndex])
				let paragraphNodes = parseNodes(markdown: paragraph, in: .paragraph)
				nodes.append(.paragraph(nodes: paragraphNodes))
				input = String(input[paragraphIndex...])
			} else {
				nodes.append(.text(input))
				input = ""
			}
		}

		return nodes
	}
}
