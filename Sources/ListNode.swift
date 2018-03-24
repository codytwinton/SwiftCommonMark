//
//  ListNode.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/23/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: Enums

enum ListType: Equatable {
	case dash, asterisk, plus
	case period(start: Int), paren(start: Int)

	var htmlPrefix: String {
		switch self {
		case .dash, .asterisk, .plus:
			return "<ul>"
		case .period(let start), .paren(let start):
			var prefix = "<ol"

			if start != 1 {
				prefix += " start=\"\(start)\""
			}

			return prefix + ">"
		}
	}

	var htmlPostfix: String {
		switch self {
		case .dash, .asterisk, .plus: return "</ul>"
		case .period, .paren: return "</ol>"
		}
	}

	var commonMarkDelimiter: String {
		switch self {
		case .dash: return "-"
		case .asterisk: return "*"
		case .plus: return "+"
		case .period: return "."
		case .paren: return ")"
		}
	}
}

// MARK: -

struct ListNode: HTMLRenderable, CommonMarkRenderable {

	// MARK: Constants

	let type: NodeType = .list

	// MARK: Variables

	private var listType: ListType
	private var isTight: Bool
	private var nodes: [CommonMark]

	// MARK: - HTMLRenderable

	var html: String {
		let content = nodes.map { $0.html }.joined()
		var list = listType.htmlPrefix + "\n"

		switch isTight {
		case true:
			list += content.tightenedList()
		case false:
			list += content.loosenedList()
		}

		return list + listType.htmlPostfix + "\n"
	}

	// MARK: - CommonMarkRenderable

	var commonMark: String {
		let delimiter = listType.commonMarkDelimiter + " "

		switch listType {
		case .dash, .asterisk, .plus:
			return nodes.map { node -> String in
				let listItem = node.commonMark.trimmingCharacters(in: .newlines)
				return delimiter + listItem + (isTight ? "\n" : "\n\n")
			}.joined() + (isTight ? "\n" : "")
		case .period(let start), .paren(let start):
			return nodes.enumerated().map { offset, node -> String in
				let listItem = node.commonMark.trimmingCharacters(in: .newlines)
				return "\(start + offset)" + delimiter + listItem + (isTight ? "\n" : "\n\n")
			}.joined() + (isTight ? "\n" : "")
		}
	}
}

// MARK: -

private extension String {

	func tightenedList() -> String {
		return replacingOccurrences(of: "<li><p>", with: "<li>")
			.replacingOccurrences(of: "</p>\n</li>", with: "</li>")
	}

	func loosenedList() -> String {
		return replacingOccurrences(of: "<li><p>", with: "<li>\n<p>")
	}

	func trimmingParagraph() -> String {
		let pStart = "<p>"
		let pEnd = "</p>"

		let sIndex = index(startIndex, offsetBy: pStart.count)
		let eIndex = index(endIndex, offsetBy: -pEnd.count)

		guard self[..<sIndex] == pStart, self[eIndex...] == pEnd else { return self }
		return String(self[sIndex..<eIndex])
	}
}
