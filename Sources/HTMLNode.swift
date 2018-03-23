//
//  HTMLNode.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/23/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: Enums

enum HTMLType {
	case block, inline

	var type: NodeType {
		switch self {
		case .block: return .htmlBlock
		case .inline: return .htmlInline
		}
	}
}

// MARK: -

struct HTMLNode: HTMLRenderable, CommonMarkRenderable {

	// MARK: Variables

	private var content: String
	private var htmlType: HTMLType

	private var type: NodeType {
		return htmlType.type
	}

	// MARK: - HTMLRenderable

	var html: String {
		switch htmlType {
		case .block: return content + "\n"
		case .inline: return content
		}
	}

	// MARK: - CommonMarkRenderable

	var commonMark: String {
		switch htmlType {
		case .block: return content + "\n\n"
		case .inline: return content
		}
	}
}
