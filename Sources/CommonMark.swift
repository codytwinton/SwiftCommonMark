//
//  CommonMark.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/8/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: Type Aliases

typealias CommonMark = HTMLRenderable & CommonMarkRenderable

// MARK: Protocols

protocol CommonMarkRenderable {
	var commonMark: String { get }
}

protocol HTMLRenderable {
	var html: String { get }
}

// MARK: -

enum NodeType: String, EnumProtocol {
	case blockQuote, code, codeBlock, document, emphasis, heading, htmlBlock, htmlInline, image
	case lineBreak, link, list, listItem, paragraph, softBreak, strong, text, thematicBreak
}

// MARK: -

enum Node: Equatable {

	// MARK: Cases

	case blockQuote(nodes: [Node])
	case code(String)
	case codeBlock(info: String?, code: String)
	case document(nodes: [Node])
	case emphasis(nodes: [Node])
	case heading(level: HeadingLevel, nodes: [Node])
	case htmlBlock(String)
	case htmlInline(String)
	case image(source: String, title: String?, alternate: String)
	case lineBreak
	case link(url: String, title: String?, nodes: [Node])
	case list(type: ListType, isTight: Bool, nodes: [Node])
	case listItem(nodes: [Node])
	case paragraph(nodes: [Node])
	case softBreak
	case strong(nodes: [Node])
	case text(String)
	case thematicBreak

	// MARK: Variables

	var type: NodeType {
		switch self {
		case .blockQuote: return .blockQuote
		case .code: return .code
		case .codeBlock: return .codeBlock
		case .document: return .document
		case .emphasis: return .emphasis
		case .heading: return .heading
		case .htmlBlock: return .htmlBlock
		case .htmlInline: return .htmlInline
		case .image: return .image
		case .list: return .list
		case .lineBreak: return .lineBreak
		case .link: return .link
		case .listItem: return .listItem
		case .paragraph: return .paragraph
		case .softBreak: return .softBreak
		case .strong: return .strong
		case .text: return .text
		case .thematicBreak: return .thematicBreak
		}
	}
}

// MARK: - Equatable Functions

func == (lhs: Node, rhs: Node) -> Bool {
	switch (lhs, rhs) {
	case let (.image(lSource, lTitle, lAlternate), .image(rSource, rTitle, rAlternate)):
		return lSource == rSource && lTitle == rTitle && lAlternate == rAlternate
	case let (.link(lURL, lTitle, lNodes), .link(rURL, rTitle, rNodes)):
		return lURL == rURL && lTitle == rTitle && lNodes == rNodes
	case let (.codeBlock(lInfo, lCode), .codeBlock(rInfo, rCode)):
		return lInfo == rInfo && lCode == rCode
	case let (.list(lType, lIsTight, lNodes), .list(rType, rIsTight, rNodes)):
		return lType == rType && lIsTight == rIsTight && lNodes == rNodes
	case let (.heading(lLevel, lNodes), .heading(rLevel, rNodes)):
		return lLevel == rLevel && lNodes == rNodes
	case let (.code(left), .code(right)),
		 let (.htmlBlock(left), .htmlBlock(right)),
		 let (.htmlInline(left), .htmlInline(right)),
		 let (.text(left), .text(right)):
		return left == right
	case let (.blockQuote(lNodes), .blockQuote(rNodes)),
		 let (.emphasis(lNodes), .emphasis(rNodes)),
		 let (.listItem(lNodes), .listItem(rNodes)),
		 let (.paragraph(lNodes), .paragraph(rNodes)),
		 let (.strong(lNodes), .strong(rNodes)),
		 let (.document(lNodes), .document(rNodes)):
		return lNodes == rNodes
	case (.thematicBreak, .thematicBreak),
		 (.softBreak, .softBreak),
		 (.lineBreak, .lineBreak):
		return true
	default:
		return false
	}
}

func == (lhs: [Node], rhs: [Node]) -> Bool {
	guard lhs.count == rhs.count else { return false }

	for (i, node) in lhs.enumerated() {
		guard node == rhs[i] else { return false }
	}

	return true
}

func == (lhs: ListType, rhs: ListType) -> Bool {
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
