//
//  HeadingNode.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/23/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: Enums

enum HeadingLevel: Int, EnumProtocol {
	case h1 = 1, h2, h3, h4, h5, h6
}

// MARK: Equatable Extensions

func == (lhs: HeadingNode?, rhs: HeadingNode?) -> Bool {
	guard lhs?.level == rhs?.level else { return false }
	return lhs?.html == rhs?.html
}

func == (lhs: HeadingNode, rhs: HeadingNode) -> Bool {
	guard lhs.level == rhs.level else { return false }
	return lhs.html == rhs.html
}

// MARK: -

struct HeadingNode: CommonMarkBlockNode, Equatable {

	// MARK: Constants

	let type: NodeType = .heading

	// MARK: Variables

	private(set) var level: HeadingLevel
	private(set) var nodes: [CommonMarkNode]

	// MARK: - HTMLRenderable

	var html: String {
		return "<\(level)>" + nodes.html + "</\(level)>\n"
	}

	// MARK: - CommonMarkRenderable

	var commonMark: String {
		return String(repeating: "#", count: level.rawValue) + " " + nodes.commonMark + "\n\n"
	}

	// MARK: - Inits

	init(level: HeadingLevel, nodes: [CommonMarkNode]) {
		self.level = level
		self.nodes = nodes
	}

	init?(blockLine line: String) {
		guard !line.isEmpty else { return nil }

		let pattern = "^ {0,3}(#{1,6})(?:[ \t]+|$)(.*)"
		guard let regex = try? NSRegularExpression(pattern: pattern, options: .anchorsMatchLines) else { return nil }

		let range = NSRange(location: 0, length: line.count)
		let options: NSRegularExpression.MatchingOptions = .anchored

		guard let match = regex.firstMatch(in: line, options: options, range: range),
			match.range.location != NSNotFound else {
				return nil
		}

		let matchString = NSString(string: line).substring(with: match.range)
		var captures: [String] = []

		for template in ["$1", "$2"] {
			let text: String = regex.replacementString(for: match, in: matchString, offset: 0, template: template)
			captures.append(text)
		}

		level = HeadingLevel(rawValue: captures.first?.count ?? 0) ?? .h1

		let raw = captures[1]
		var components = raw.components(separatedBy: " #")

		if let last = components.last?.trimmingCharacters(in: .whitespaces) {
			let set = Set(last)
			if set.count == 1, set.first == "#" {
				components.removeLast()
			}
		}

		let markdown = components.joined(separator: " #")
			.replacingOccurrences(of: "\\#", with: "#")
			.trimmingCharacters(in: .whitespaces)
		nodes = [TextNode(markdown)]
	}
}
