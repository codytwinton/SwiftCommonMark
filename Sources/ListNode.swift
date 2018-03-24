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

	static func == (lhs: ListType, rhs: ListType) -> Bool {
		switch (lhs, rhs) {
		case (.dash, .dash),
			 (.asterisk, .asterisk),
			 (.plus, .plus):
			return true
		case let (.period(lStart), .period(rStart)),
			 let (.paren(lStart), .paren(rStart)):
			return lStart == rStart
		default:
			return false
		}
	}
}

// MARK: -

struct ListNode: CommonMarkNode {

	// MARK: Constants

	let type: NodeType = .list

	// MARK: Variables

	private(set) var listType: ListType
	private(set) var isTight: Bool
	private(set) var nodes: [CommonMarkNode]

	// MARK: - HTMLRenderable

	var html: String {
		var list = listType.htmlPrefix + "\n"

		switch isTight {
		case true: list += nodes.html.tightenedList()
		case false: list += nodes.html.loosenedList()
		}

		return list + listType.htmlPostfix + "\n"
	}

	// MARK: - CommonMarkRenderable

	var commonMark: String {
		let delimiter = listType.commonMarkDelimiter + " "
		var items = nodes.map { $0.commonMark.trimmingCharacters(in: .newlines) }

		switch listType {
		case .dash, .asterisk, .plus:
			items = items.map { delimiter + $0 }
		case .period(let start), .paren(let start):
			items = items.enumerated().map { "\(start + $0.offset)" + delimiter + $0.element }
		}

		return items.map { $0 + (isTight ? "\n" : "\n\n") }.joined() + (isTight ? "\n" : "")
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
