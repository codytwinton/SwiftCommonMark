//
//  BreakNode.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/23/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: Protocols

enum BreakType {
	case softBreak, lineBreak, thematicBreak

	var type: NodeType {
		switch self {
		case .softBreak: return .softBreak
		case .lineBreak: return .lineBreak
		case .thematicBreak: return .thematicBreak
		}
	}
}

// MARK: -

struct BreakNode: HTMLRenderable, CommonMarkRenderable {

	// MARK: Variables

	private var breakType: BreakType

	var type: NodeType {
		return breakType.type
	}

	// MARK: - HTMLRenderable

	var html: String {
		switch breakType {
		case .softBreak:
			return "\n"
		case .lineBreak:
			return "<br />\n"
		case .thematicBreak:
			return "<hr />\n"
		}
	}

	// MARK: - CommonMarkRenderable

	var commonMark: String {
		switch breakType {
		case .softBreak:
			return "\n"
		case .lineBreak:
			return "\\\n"
		case .thematicBreak:
			return "***\n\n"
		}
	}
}
