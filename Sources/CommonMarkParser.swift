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
		return parseBlocks(markdown: markdown)
	}

	static func parseBlocks(markdown: String) -> Node {

		var blocks: [Node] = []
		var openBlocks: [NodeType] = [.document]

		for line in markdown.components(separatedBy: "\n") {
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
			}
		}

		return .document(nodes: blocks)
	}
}
