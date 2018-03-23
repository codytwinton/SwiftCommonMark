//
//  HTMLRenderable.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/8/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: - Protocols

protocol HTMLRenderable {
	var html: String { get }
}

// MARK: - Extensions

// MARK: - HTML Output Extensions

extension Node: HTMLRenderable {

	var html: String {
		switch self {
		case .blockQuote, .code, .codeBlock, .document, .emphasis, .heading, .htmlBlock,
			 .htmlInline, .image, .lineBreak, .softBreak, .strong, .text, .thematicBreak:
			return ""
		case .paragraph(let nodes):
			return "<p>" + nodes.html + "</p>\n"
		case .listItem(let nodes):
			return "<li>" + nodes.html + "</li>\n"
		case let .list(type, isTight, nodes):
			var list = type.htmlPrefix + "\n"

			switch isTight {
			case true:
				list += nodes.html.tightenedList()
			case false:
				list += nodes.html.loosenedList()
			}

			return list + type.htmlPostfix + "\n"
		case let .link(url, title, nodes):
			var link = "<a href=\"\(url)\""

			if let title = title, !title.isEmpty {
				link += " title=\"\(title)\""
			}

			return link + ">" + nodes.html + "</a>"
		}
	}
}

extension Array where Element: HTMLRenderable {

	var html: String {
		return map { $0.html }.joined()
	}
}

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
