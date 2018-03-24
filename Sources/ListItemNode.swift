//
//  ListItemNode.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/23/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: -

struct ListItemNode: CommonMarkNode {

	// MARK: Constants

	let type: NodeType = .listItem

	// MARK: Variables

	private(set) var nodes: [CommonMarkNode]

	// MARK: - HTMLRenderable

	var html: String {
		return "<li>" + nodes.html + "</li>\n"
	}

	// MARK: - CommonMarkRenderable

	var commonMark: String {
		return nodes.commonMark + "\n"
	}
}
