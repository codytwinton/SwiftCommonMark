//
//  Node+Extensions.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/6/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: Parsing Markdown

extension NodeType {

	// MARK: Variables

	var subNodes: [NodeType] {
		switch self {
		case .document:
			return [.thematicBreak, .codeBlock, .blockQuote, .heading, .list, .htmlBlock, .paragraph]
		case .heading, .strong, .emphasis, .paragraph:
			return [.thematicBreak, .heading, .strong, .emphasis]
		case .blockQuote, .code, .codeBlock, .htmlBlock, .htmlInline, .image,
			 .listItem, .lineBreak, .link, .list, .softBreak, .text, .thematicBreak:
			return []
		}
	}

	var regex: NSRegularExpression? {
		let pattern: String

		switch self {
		case .heading:
			pattern = "^ {0,3}(#{1,6})(?:[ \t]+|$)(.*)"
		case .thematicBreak:
			pattern = "^(?:(?:[ ]{0,3}\\*[ \t]*){3,}|(?:[ ]{0,3}_[ \t]*){3,}|(?:[ ]{0,3}-[ \t]*){3,})[ \t]*$"
		case .strong:
			pattern = "([*_]{2})([\\w(]+.*[\\w)]+)(\\1)"
		case .emphasis:
			pattern = "([*_]{1})([\\w(]+.*[\\w)]+)(\\1)"
		case .blockQuote, .code, .codeBlock, .document, .htmlBlock, .htmlInline,
			 .image, .listItem, .lineBreak, .link, .list, .paragraph, .softBreak, .text:
			return nil
		}

		return try? NSRegularExpression(pattern: pattern, options: .anchorsMatchLines)
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
			 .htmlInline, .image, .listItem, .lineBreak, .link, .list,
			 .paragraph, .softBreak, .text, .thematicBreak:
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

			for subNode in subNodes {
				guard let regexMatch = subNode.regex?.match(in: input, templates: subNode.regexTemplates) else { continue }
				let result = subNode.node(from: regexMatch.captures)
				nodes.append(result)

				let inputOffset = input.index(input.startIndex, offsetBy: regexMatch.fullMatch.count)
				input = String(input[inputOffset...])
				isMatched = true
				break
			}

			guard !isMatched, let first = input.first else { continue }

			if first == "\n" {
				// Ignore Newlines Characters
				input.removeFirst()
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

	func node(from matches: [String]) -> Node {
		switch self {
		case .thematicBreak:
			return .thematicBreak
		case .heading:
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
		case .strong:
			return .strong(nodes: NodeType.strong.parse(markdown: matches[0]))
		case .emphasis:
			return .emphasis(nodes: NodeType.emphasis.parse(markdown: matches[0]))
		case .document, .blockQuote, .code, .codeBlock, .htmlBlock, .htmlInline,
			 .image, .listItem, .lineBreak, .link, .list, .paragraph, .softBreak, .text:
			return .text("")
		}
	}
}
