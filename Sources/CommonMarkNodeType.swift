//
//  CommonMarkNodeType.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/6/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

import Foundation

enum CommonMarkNodeType {
	case blockQuote
	case code
	case codeBlock
	case document
	case emphasis
	case heading
	case htmlBlock
	case htmlInline
	case image
	case item
	case lineBreak
	case link
	case list
	case paragraph
	case softBreak
	case strong
	case text
	case thematicBreak
	case customInline
	case customBlock

	var regex: String {
		switch self {
		case .heading:
			return "^ {0,3}(#{1,6})(?:[ \t]+|$)(.*)"
		case .thematicBreak:
			return "^(?:(?:[ ]{0,3}\\*[ \t]*){3,}|(?:[ ]{0,3}_[ \t]*){3,}|(?:[ ]{0,3}-[ \t]*){3,})[ \t]*$"
		case .blockQuote, .code, .document, .emphasis, .htmlBlock,
			 .htmlInline, .image, .item, .lineBreak, .link, .list, .paragraph, .softBreak,
			 .strong, .text, .customInline, .customBlock:
			return ""
		}
	}

	var regexTemplates: [String] {
		switch self {
		case .heading:
			return ["$1", "$2"]
		case .strong, .emphasis, .blockQuote, .code, .document, .htmlBlock,
			 .htmlInline, .image, .item, .lineBreak, .link, .list, .paragraph, .softBreak,
			 .text, .thematicBreak, .customInline, .customBlock:
			return []
		}
	}
}
