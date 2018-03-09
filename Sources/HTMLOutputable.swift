//
//  HTMLOutputable.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/8/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: - Protocols

protocol HTMLOutputable {
	var html: String { get }
}

// MARK: - Extensions

// MARK: - HTML Output Extensions

extension Node: HTMLOutputable {

	var html: String {
		switch self {
		case .softBreak:
			return "\n"
		case .lineBreak:
			return "<br />"
		case .thematicBreak:
			return "<hr />"
		case .document(let nodes):
			return nodes.html
		case .text(let str), .htmlInline(let str), .htmlBlock(let str):
			return str.trimmingCharacters(in: .whitespaces).sanatizeHTML()
		case .code(let code):
			return "<code>" + code + "</code>"
		case .strong(let nodes):
			return "<strong>" + nodes.html + "</strong>"
		case .emphasis(let nodes):
			return "<em>" + nodes.html + "</em>"
		case .paragraph(let nodes):
			return "<p>" + nodes.html + "</p>"
		case let .heading(level, nodes):
			return "<\(level)>" + nodes.html + "</\(level)>"
		case let .codeBlock(lang, code):
			let prefix: String
			switch lang {
			case let lang?:
				prefix = "<pre><code class=\"language-\(lang)\">"
			case nil:
				prefix = "<pre><code></pre>"
			}
			return prefix + code + "</code></pre>"

		case .blockQuote, .listItem, .item,
			 .link, .image, .customInline, .customBlock:
			return ""
		}
	}
}

extension Array where Element: HTMLOutputable {

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
		case "/": return "&#47;"
		case "(": return "&#40;"
		case ")": return "&#41;"
		case "{": return "&#123;"
		case "}": return "&#125;"
		case "\"": return "&quot;"
		default: return String(self)
		}
	}
}

private extension String {

	func sanatizeHTML() -> String {
		return map { $0.sanatizeHTML() }.joined()
	}
}
