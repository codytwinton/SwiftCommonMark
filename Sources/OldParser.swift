//
//  CommonMarkParser.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/16/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: -

extension NodeType {

	// MARK: Variables

	var regex: NSRegularExpression? {
		let pattern: String
		let options: NSRegularExpression.Options = .anchorsMatchLines

		switch self {
		case .code:
			pattern = "(\\`+)([^\\`]{1}[\\s\\S\\\\]*?[^\\`]*)\\1"
		case .emphasis:
			pattern = "([*_]{1})([\\w(]+.*[\\w)]+)(\\1)"
		case .heading:
			pattern = "^ {0,3}(#{1,6})(?:[ \t]+|$)(.*)"
		case .strong:
			pattern = "([*_]{2})([\\w(]+.*[\\w)]+)(\\1)"
		case .thematicBreak:
			pattern = "^(?:(?:[ ]{0,3}\\*[ \t]*){3,}|(?:[ ]{0,3}_[ \t]*){3,}|(?:[ ]{0,3}-[ \t]*){3,})[ \t]*$"
		case .blockQuote, .codeBlock, .document, .htmlBlock, .htmlInline,
			 .image, .listItem, .lineBreak, .link, .list, .paragraph, .softBreak, .text:
			return nil
		}

		return try? NSRegularExpression(pattern: pattern, options: options)
	}

	var regexTemplates: [String] {
		switch self {
		case .heading:
			return ["$1", "$2"]
		case .strong, .emphasis, .code:
			return ["$2"]
		case .blockQuote, .codeBlock, .document, .htmlBlock,
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

			for child in childNodes {
				guard let regexMatch = child.regex?.match(in: input, templates: child.regexTemplates) else { continue }
				let result = child.node(from: regexMatch.captures)
				nodes.append(result)

				let inputOffset = input.index(input.startIndex, offsetBy: regexMatch.fullMatch.count)
				input = String(input[inputOffset...])
				isMatched = true
				break
			}

			guard !isMatched else { continue }

			if input.first == "\n" {
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
		case .code:
			return .code(matches[0])
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
			return .heading(level: level, nodes: [.text(markdown)])
		case .strong:
			return .strong(nodes: NodeType.strong.parse(markdown: matches[0]))
		case .emphasis:
			return .emphasis(nodes: NodeType.emphasis.parse(markdown: matches[0]))
		case .document, .blockQuote, .codeBlock, .htmlBlock, .htmlInline,
			 .image, .listItem, .lineBreak, .link, .list, .paragraph, .softBreak, .text:
			return .text("")
		}
	}

	// MARK: -

	static func parse(markdown: String) -> Node {

		var blocks: [Node] = []
		var openBlocks: [NodeType] = [.document]

		for line in markdown.components(separatedBy: .newlines) {

			var foundMatch = false

			for type in blockTypes {
				guard let regex = type.blockRegex else { continue }

				let options: NSRegularExpression.MatchingOptions = .anchored
				guard let match = regex.firstMatch(in: line, options: options, range: NSRange(location: 0, length: line.count)),
					match.range.location != NSNotFound else {
						continue
				}

				let matchString = NSString(string: line).substring(with: match.range)
				var captures = Array(repeating: "", count: type.blockTemplates.count)

				for (index, template) in type.blockTemplates.enumerated() {
					let text: String = regex.replacementString(for: match, in: matchString, offset: 0, template: template)
					captures[index] = text
				}

				blocks.append(type.block(from: line, captures: captures))
				foundMatch = true
				break
			}

			guard !foundMatch else { continue }
			parseParagraph(line: line, &blocks, &openBlocks)
		}

		var document = Node.document(nodes: blocks)
		document.parseBlockInlines()
		return document
	}

	// MARK: Specific Parsing

	private static func parseParagraph(line: String, _ blocks: inout [Node], _ openBlocks: inout [NodeType]) {

		switch blocks.last {
		case .paragraph(var nodes)? where openBlocks.last == .paragraph:
			if let node = nodes.last, case .text(let text) = node, text.last != "\n" {
				blocks.removeLast()
				nodes.removeLast()

				nodes.append(.text(text + "\n" + line))
				blocks.append(.paragraph(nodes: nodes))
			} else if !line.isEmpty {
				blocks.append(.paragraph(nodes: [.text(line)]))
			}

		default:
			if !line.isEmpty {
				blocks.append(.paragraph(nodes: [.text(line)]))
				openBlocks.append(.paragraph)
			}
		}
	}
}

// MARK: -

private extension Node {

	mutating func parseBlockInlines() {
		switch self {
		case .paragraph(let nodes):
			self = .paragraph(nodes: nodes.flatMap { node -> [Node] in
				guard case .text(let text) = node else { return [] }
				return text.parseParagraphInlines()
			})
		case let .heading(level, nodes):
			self = .heading(level: level, nodes: nodes.flatMap { node -> [Node] in
				guard case .text(let text) = node else { return [] }
				return text.parseHeadingInlines()
			})
		case .document(var nodes):
			nodes.parseBlockInlines()
			self = .document(nodes: nodes)
		case .blockQuote(var nodes):
			nodes.parseBlockInlines()
			self = .blockQuote(nodes: nodes)
		case .list(let type, let isTight, var nodes):
			nodes.parseBlockInlines()
			self = .list(type: type, isTight: isTight, nodes: nodes)
		case .listItem(var nodes):
			nodes.parseBlockInlines()
			self = .listItem(nodes: nodes)
		case .code, .codeBlock, .emphasis, .image, .htmlBlock, .htmlInline,
			 .lineBreak, .link, .softBreak, .strong, .text, .thematicBreak:
			break
		}
	}
}

// MARK: -

private extension Array where Element == Node {

	mutating func parseBlockInlines() {
		for i in 0..<count {
			self[i].parseBlockInlines()
		}
	}
}

// MARK: -

private extension String {

	func parseParagraphInlines() -> [Node] {
		var nodes: [Node] = []

		let lines = trimmingCharacters(in: .newlines).components(separatedBy: .newlines)

		for (i, line) in lines.enumerated() {
			guard !line.isEmpty else { continue }
			nodes.append(.text(line))
			guard i < lines.count - 1 else { continue }
			nodes.append(.softBreak)
		}

		return nodes
	}

	func parseHeadingInlines() -> [Node] {
		return [.text(self)]
	}
}
