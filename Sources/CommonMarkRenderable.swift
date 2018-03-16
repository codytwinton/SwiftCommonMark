//
//  CommonMarkRenderable.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/8/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: - Protocols

protocol CommonMarkRenderable {
	var commonMark: String { get }
}

// MARK: - Extensions

// MARK: - CommonMark Output Extensions

extension Node: CommonMarkRenderable {

	var commonMark: String {
		switch self {
		case .softBreak:
			return "\n"
		case .lineBreak:
			return "\\\n"
		case .thematicBreak:
			return "***\n\n"
		case .document(let nodes):
			return nodes.commonMark.trimmingCharacters(in: .newlines) + "\n"
		case .paragraph(let nodes):
			return nodes.commonMark + "\n\n"
		case .text(let str), .htmlInline(let str):
			return str
		case .htmlBlock(let str):
			return str + "\n\n"
		case .code(let code):
			return "`" + code.trimmingCharacters(in: .whitespacesAndNewlines) + "`"
		case .strong(let nodes):
			return "**" + nodes.commonMark + "**"
		case .emphasis(let nodes):
			return "*" + nodes.commonMark + "*"
		case let .heading(level, nodes):
			return String(repeating: "#", count: level.rawValue) + " " + nodes.commonMark + "\n\n"
		case let .codeBlock(info, code):
			let info = info ?? ""
			return "```\(info)\n" + code + "```\n\n"
		case let .image(source, title, alternate):
			var srcTitle = ""

			if let title = title {
				srcTitle += " \"" + title + "\""
			}

			return "![\(alternate)](\(source)\(srcTitle))"
		case .blockQuote(let nodes):
			return nodes.map { "> " + $0.commonMark }.joined().replacingOccurrences(of: "\n\n> ", with: "\n>\n> ")
		case let .link(url, title, nodes):
			var srcTitle = ""

			if let title = title {
				srcTitle += " \"" + title + "\""
			}

			return "[\(nodes.commonMark)](\(url)\(srcTitle))"
		case .listItem(let nodes):
			return nodes.commonMark + "\n"
		case let .list(type, isTight, nodes):
			let delimiter = type.commonMarkDelimiter + " "

			switch type {
			case .dash, .asterisk, .plus:
				return nodes.map { delimiter + $0.commonMark }.joined() + "\n"
			case .period(let start), .paren(let start):
				return nodes.enumerated().map { "\(start + $0.offset)" + delimiter + $0.element.commonMark }.joined() + "\n"
			}
		}
	}
}

extension Array where Element: CommonMarkRenderable {

	var commonMark: String {
		return map { $0.commonMark }.joined()
	}
}
