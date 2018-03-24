//
//  ParagraphNode.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/23/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: -

struct ParagraphNode: CommonMarkNode {

	// MARK: Constants

	let type: NodeType = .paragraph

	// MARK: Variables

	private(set) var nodes: [CommonMarkNode]

	// MARK: - HTMLRenderable

	var html: String {
		return "<p>" + nodes.html + "</p>\n"
	}

	// MARK: - CommonMarkRenderable

	var commonMark: String {
		return nodes.commonMark + "\n\n"
	}
}
