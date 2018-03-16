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

// MARK: -

enum HeadingLevel: Int, EnumProtocol {
	case h1 = 1, h2, h3, h4, h5, h6
}

// MARK: -

enum NodeType: String, EnumProtocol {
	case blockQuote, code, codeBlock, document, emphasis, heading, htmlBlock, htmlInline, image
	case lineBreak, link, list, listItem, paragraph, softBreak, strong, text, thematicBreak
}

// MARK: -

enum Node {

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
	case list(isOrdered: Bool, nodes: [Node])
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
