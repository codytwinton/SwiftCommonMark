//
//  DocumentNode.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/23/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: -

struct DocumentNode: CommonMarkNode {

	// MARK: Constants

	let type: NodeType = .document

	// MARK: Variables

	private(set) var nodes: [CommonMarkNode]

	// MARK: - HTMLRenderable

	var html: String {
		return nodes.html
	}

	// MARK: - CommonMarkRenderable

	var commonMark: String {
		return nodes.commonMark.trimmingCharacters(in: .newlines) + "\n"
	}

	// MARK: - Inits

	init(nodes: [CommonMarkNode]) {
		self.nodes = nodes
	}
}
