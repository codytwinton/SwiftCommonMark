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
		case .blockQuote, .code, .codeBlock, .document, .emphasis, .heading, .htmlBlock,
			 .htmlInline, .image, .lineBreak, .softBreak, .strong, .thematicBreak:
			return ""
		case .paragraph(let nodes):
			return nodes.commonMark + "\n\n"
		case .text(let str):
			return str
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
}

extension Array where Element: CommonMarkRenderable {

	var commonMark: String {
		return map { $0.commonMark }.joined()
	}
}
