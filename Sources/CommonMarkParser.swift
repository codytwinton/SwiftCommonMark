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
/*
enum NodeType: String, EnumProtocol {
	case blockQuote, code, codeBlock, document, emphasis, heading, htmlBlock, htmlInline, image
	case lineBreak, link, list, listItem, paragraph, softBreak, strong, text, thematicBreak
}
*/

extension NodeType {

	// MARK: Static Variables

	static var blockTypes: [NodeType] {
		return [.codeBlock, .blockQuote, .heading, .thematicBreak, .list, .htmlBlock, .paragraph]
	}

	// MARK: Variables

	var blockRegex: NSRegularExpression? {
		let pattern: String

		switch self {
		case .thematicBreak:
			pattern = "^(?:(?:[ ]{0,3}\\*[ \t]*){3,}|(?:[ ]{0,3}_[ \t]*){3,}|(?:[ ]{0,3}-[ \t]*){3,})[ \t]*$"
		case .heading:
			pattern = "^ {0,3}(#{1,6})(?:[ \t]+|$)(.*)"
		case .blockQuote, .code, .codeBlock, .document, .emphasis, .htmlBlock, .htmlInline,
			 .image, .listItem, .lineBreak, .link, .list, .paragraph, .softBreak, .strong, .text:
			return nil
		}

		return try? NSRegularExpression(pattern: pattern, options: .anchorsMatchLines)
	}

	var blockTemplates: [String] {
		switch self {
		case .heading:
			return ["$1", "$2"]
		case .blockQuote, .code, .codeBlock, .document, .emphasis, .htmlBlock,
			 .htmlInline, .image, .listItem, .lineBreak, .link, .list,
			 .paragraph, .softBreak, .strong, .text, .thematicBreak:
			return []
		}
	}

	func block(from line: String, captures: [String]) -> Node {
		switch self {
		case .thematicBreak:
			return .thematicBreak
		case .heading:
			let level: HeadingLevel = HeadingLevel(rawValue: captures[0].count) ?? .h1
			let raw = captures[1]
			var components = raw.components(separatedBy: " #")

			if let last = components.last?.trimmingCharacters(in: .whitespaces) {
				let set = Set(last)
				if set.count == 1, set.first == "#" {
					components.removeLast()
				}
			}

			let markdown = components.joined(separator: " #").replacingOccurrences(of: "\\#", with: "#")
			return .heading(level: level, nodes: [.text(markdown)])
		case .code, .document, .blockQuote, .codeBlock, .emphasis, .htmlBlock, .htmlInline,
			 .image, .listItem, .lineBreak, .link, .list, .paragraph, .softBreak, .strong, .text:
			return .paragraph(nodes: [.text(line)])
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
			parseParagraphInlines(nodes: nodes)
		case let .heading(level, nodes):
			parseHeadingInlines(level: level, nodes: nodes)
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

	mutating func parseParagraphInlines(nodes: [Node]) {
		var updatedNodes: [Node] = []

		for node in nodes {
			guard case .text(let text) = node else { continue }
			updatedNodes += text.parseParagraphInlines()
		}

		self = .paragraph(nodes: updatedNodes)
	}

	mutating func parseHeadingInlines(level: HeadingLevel, nodes: [Node]) {
		var updatedNodes: [Node] = []

		for node in nodes {
			guard case .text(let text) = node else { continue }
			updatedNodes += text.parseHeadingInlines()
		}

		self = .heading(level: level, nodes: updatedNodes)
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
