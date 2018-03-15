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
	case h1 = 1
	case h2, h3, h4, h5, h6
}

// MARK: -

enum NodeType {
	case blockQuote
	case code
	case codeBlock
	case document
	case emphasis
	case heading
	case htmlBlock
	case htmlInline
	case image
	case listItem
	case lineBreak
	case link
	case list
	case paragraph
	case softBreak
	case strong
	case text
	case thematicBreak
}

// MARK: -

enum Node {

	// MARK: Cases

	case softBreak
	case lineBreak
	case thematicBreak
	case code(String)
	case htmlBlock(String)
	case htmlInline(String)
	case text(String)
	case codeBlock(language: String?, code: String)
	case image(source: String, title: String?, alternate: String)
	indirect case heading(level: HeadingLevel, nodes: [Node])
	indirect case paragraph(nodes: [Node])
	indirect case emphasis(nodes: [Node])
	indirect case strong(nodes: [Node])
	indirect case link(url: String, title: String?, nodes: [Node])
	indirect case document(nodes: [Node])
	indirect case blockQuote(nodes: [Node])
	indirect case list(isOrdered: Bool, nodes: [Node])
	indirect case listItem(nodes: [Node])

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
		case .list: return .listItem
		case .lineBreak: return .lineBreak
		case .link: return .link
		case .listItem: return .list
		case .paragraph: return .paragraph
		case .softBreak: return .softBreak
		case .strong: return .strong
		case .text: return .text
		case .thematicBreak: return .thematicBreak
		}
	}
}
