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
	case thematicBreak
	case code(String)
	case htmlBlock(String)
	case htmlInline(String)
	case lineBreak(String)
	case softBreak(String)
	case text(String)
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
}
