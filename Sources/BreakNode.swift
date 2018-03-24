//
//  BreakNode.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/23/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: -

enum BreakNode: CommonMarkNode {
	case lineBreak, softBreak, thematicBreak

	var type: NodeType {
		switch self {
		case .lineBreak: return .lineBreak
		case .softBreak: return .softBreak
		case .thematicBreak: return .thematicBreak
		}
	}

	// MARK: - HTMLRenderable

	var html: String {
		switch self {
		case .lineBreak: return "<br />\n"
		case .softBreak: return "\n"
		case .thematicBreak: return "<hr />\n"
		}
	}

	// MARK: - CommonMarkRenderable

	var commonMark: String {
		switch self {
		case .lineBreak: return "\\\n"
		case .softBreak: return "\n"
		case .thematicBreak: return "***\n\n"
		}
	}
}
