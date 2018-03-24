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

struct ListItemNode: HTMLRenderable, CommonMarkRenderable {

	// MARK: Constants

	let type: NodeType = .listItem

	// MARK: Variables

	private var nodes: [CommonMark]

	// MARK: - HTMLRenderable

	var html: String {
		return "<li>" + nodes.html + "</li>\n"
	}

	// MARK: - CommonMarkRenderable

	var commonMark: String {
		return nodes.commonMark + "\n"
	}
}
