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
		case .softBreak:
			return "\n"
		case .lineBreak:
			return "<br />\n"
		case .thematicBreak:
			return "<hr />\n"
		case .document(let nodes):
			return nodes.html
		case .text(let str):
			return str.sanatizeHTML()
		case .code(let code):
			return "<code>" + code + "</code>"
		case .strong(let nodes):
			return "<strong>" + nodes.html + "</strong>"
		case .emphasis(let nodes):
			return "<em>" + nodes.html + "</em>"
		case .paragraph(let nodes):
			return "<p>" + nodes.html + "</p>\n"
		case let .heading(level, nodes):
			return "<\(level)>" + nodes.html + "</\(level)>\n"
		case let .codeBlock(info, code):
			switch info {
			case let info?:
				return "<pre><code class=\"language-\(info)\">\(code)</code></pre>\n"
			case nil:
				return "<pre><code>\(code)</code></pre>\n"
			}
		case .blockQuote(let nodes):
			return "<blockquote>\n\(nodes.html)</blockquote>\n"
		case let .image(source, title, alternate):
			var image = "<img src=\"\(source)\" alt=\"\(alternate)\" "

			if let title = title, !title.isEmpty {
				image += "title=\"\(title)\" "
			}

			return image + "/>"
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
		case .htmlBlock(let html):
			return html + "\n"
		case .htmlInline(let html):
			return html
		}
	}
}

extension Array where Element: HTMLRenderable {

	var html: String {
		return map { $0.html }.joined()
	}
}

// MARK: Sanitized HTML Extensions

private extension Character {

	func sanatizeHTML() -> String {
		switch self {
		case "<": return "&lt;"
		case ">": return "&gt;"
		case "\"": return "&quot;"
		default: return String(self)
		}
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

	func sanatizeHTML() -> String {
		return map { $0.sanatizeHTML() }.joined()
	}
}
