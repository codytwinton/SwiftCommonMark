//
//  CommonMarkOutputable.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/8/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: - Protocols

protocol CommonMarkOutputable {
	var commonMark: String { get }
}

// MARK: - Extensions

// MARK: - CommonMark Output Extensions

extension Node: CommonMarkOutputable {

	var commonMark: String {
		switch self {
		case .thematicBreak:
			return "***"
		case .document(let nodes), .paragraph(let nodes):
			return nodes.commonMark
		case .text(let str), .softBreak(let str), .lineBreak(let str), .htmlInline(let str), .htmlBlock(let str):
			return str
		case .code(let code):
			return "`" + code + "`"
		case .strong(let nodes):
			return "**" + nodes.commonMark + "**"
		case .emphasis(let nodes):
			return "*" + nodes.commonMark + "*"
		case let .heading(level, nodes):
			return String(repeating: "#", count: level.rawValue) + " " + nodes.commonMark
		case let .codeBlock(info, code):
			let lang = info ?? ""
			return "```\(lang)" + code + "```"
		case let .image(source, title, alternate):
			let alt = alternate ?? ""
			var srcTitle = ""

			if let title = title {
				srcTitle += " " + title
			}

			return "![\(alt)](\(source)\(srcTitle))"
		case .blockQuote, .list, .item,
			 .link, .customInline, .customBlock:
			return ""
		}
	}
}

extension Array where Element: CommonMarkOutputable {

	var commonMark: String {
		return map { $0.commonMark }.joined()
	}
}
