//
//  CommonMarkNode.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/5/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

import Foundation

enum HeadingLevel: Int, EnumProtocol {
	case h1 = 1
	case h2, h3, h4, h5, h6

	func html(_ raw: String) -> String {
		return "<\(self)>\(raw)</\(self)>"
	}
}

enum CommonMarkNode {
	case code(String)
	case htmlBlock(String)
	case htmlInline(String)
	case lineBreak(String)
	case softBreak(String)
	case text(String)
	case thematicBreak(String)
	case codeBlock(lang: String?, code: String)
	indirect case heading(level: HeadingLevel, nodes: [CommonMarkNode])
	indirect case image(url: String, nodes: [CommonMarkNode])
	indirect case paragraph(nodes: [CommonMarkNode])
	indirect case emphasis(nodes: [CommonMarkNode])
	indirect case strong(nodes: [CommonMarkNode])
	indirect case link(url: String, nodes: [CommonMarkNode])
	indirect case document(nodes: [CommonMarkNode])
	indirect case blockQuote(nodes: [CommonMarkNode])
	indirect case item(nodes: [CommonMarkNode])
	indirect case list(isOrdered: Bool, nodes: [CommonMarkNode])
	indirect case customInline(nodes: [CommonMarkNode])
	indirect case customBlock(nodes: [CommonMarkNode])

	var html: String {
		switch self {
		case .document(let nodes):
			return nodes.html
		case .text(let str), .softBreak(let str), .lineBreak(let str), .htmlInline(let str), .htmlBlock(let str):
			return str.trimmingCharacters(in: .whitespaces)
		case .code(let code):
			return "<code>" + code + "</code>"
		case .strong(let nodes):
			return "<strong>" + nodes.html + "</strong>"
		case .emphasis(let nodes):
			return "<em>" + nodes.html + "</em>"
		case .paragraph(let nodes):
			return "<p>" + nodes.html + "</p>"
		case let .heading(level, nodes):
			var htmlComponents = nodes.html.components(separatedBy: " #")

			if htmlComponents.count > 1 {
				htmlComponents.removeLast()
			}

			return level.html(htmlComponents.joined().trimmingCharacters(in: .whitespaces))
		case let .codeBlock(lang, code):
			let prefix: String
			switch lang {
			case let lang?:
				prefix = "<pre><code class=\"language-\(lang)\">"
			case nil:
				prefix = "<pre><code></pre>"
			}
			return prefix + code + "</code></pre>"

		case .thematicBreak, .blockQuote, .list, .item,
			 .link, .image, .customInline, .customBlock:
			return ""
		}
	}
}

extension Array where Iterator.Element == CommonMarkNode {

	var html: String {
		return map { $0.html }.joined()
	}
}
