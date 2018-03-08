//
//  Node.swift
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

enum Node {
	case thematicBreak
	case code(String)
	case htmlBlock(String)
	case htmlInline(String)
	case lineBreak(String)
	case softBreak(String)
	case text(String)
	case codeBlock(lang: String?, code: String)
	indirect case heading(level: HeadingLevel, nodes: [Node])
	indirect case image(url: String, nodes: [Node])
	indirect case paragraph(nodes: [Node])
	indirect case emphasis(nodes: [Node])
	indirect case strong(nodes: [Node])
	indirect case link(url: String, nodes: [Node])
	indirect case document(nodes: [Node])
	indirect case blockQuote(nodes: [Node])
	indirect case item(nodes: [Node])
	indirect case list(isOrdered: Bool, nodes: [Node])
	indirect case customInline(nodes: [Node])
	indirect case customBlock(nodes: [Node])
}
