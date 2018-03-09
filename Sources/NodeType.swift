//
//  NodeType.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/6/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: -

enum NodeType {

	// MARK: Cases

	case blockQuote
	case code
	case codeBlock
	case document
	case emphasis
	case heading
	case htmlBlock
	case htmlInline
	case image
	case item
	case lineBreak
	case link
	case list
	case paragraph
	case softBreak
	case strong
	case text
	case thematicBreak
	case customInline
	case customBlock

	// MARK: Variables

	var regex: String {
		switch self {
		case .heading:
			return "^ {0,3}(#{1,6})(?:[ \t]+|$)(.*)"
		case .thematicBreak:
			return "^(?:(?:[ ]{0,3}\\*[ \t]*){3,}|(?:[ ]{0,3}_[ \t]*){3,}|(?:[ ]{0,3}-[ \t]*){3,})[ \t]*$"
		case .strong:
			return "([*_]{2})([\\w(]+.*[\\w)]+)(\\1)"
		case .emphasis:
			return "([*_]{1})([\\w(]+.*[\\w)]+)(\\1)"
		case .blockQuote, .code, .codeBlock, .document, .htmlBlock,
			 .htmlInline, .image, .item, .lineBreak, .link, .list, .paragraph, .softBreak,
			 .text, .customInline, .customBlock:
			return ""
		}
	}

	var regexTemplates: [String] {
		switch self {
		case .heading:
			return ["$1", "$2"]
		case .strong:
			return ["$2"]
		case .emphasis:
			return ["$2"]
		case .blockQuote, .code, .codeBlock, .document, .htmlBlock,
			 .htmlInline, .image, .item, .lineBreak, .link, .list, .paragraph, .softBreak,
			 .text, .thematicBreak, .customInline, .customBlock:
			return []
		}
	}

	// MARK: Functions

	func parse(markdown: String) -> [Node] {

		var nodes: [Node] = []
		guard !markdown.isEmpty else { return nodes }

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
			} else if self == .document, let paragraphIndex = input.index(of: "\n") {
				let paragraph = String(input[..<paragraphIndex])
				let paragraphNodes = NodeType.paragraph.parse(markdown: paragraph)
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

// MARK: -

struct NodeParser {
	let type: NodeType
	let generator: ([String]) -> Node
}

let parsers: [NodeParser] = [
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
		return .heading(level: level, nodes: NodeType.heading.parse(markdown: markdown))
	},
	NodeParser(type: .strong) { matches in
		return .strong(nodes: NodeType.strong.parse(markdown: matches[0]))
	},
	NodeParser(type: .emphasis) { matches in
		return .emphasis(nodes: NodeType.emphasis.parse(markdown: matches[0]))
	}
]
