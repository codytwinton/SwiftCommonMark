//
//  EmphasisNode.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/23/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: -

struct EmphasisNode: CommonMarkNode {

	// MARK: Constants

	let type: NodeType = .emphasis

	// MARK: Variables

	private(set) var nodes: [CommonMarkNode]

	private var regexPattern: String {
		return "([*_]{1})([\\w(]+.*[\\w)]+)(\\1)"
	}

	private var regexTemplates: [String] {
		return ["$2"]
	}

	// MARK: - HTMLRenderable

	var html: String {
		return "<em>" + nodes.html + "</em>"
	}

	// MARK: - CommonMarkRenderable

	var commonMark: String {
		return "*" + nodes.commonMark + "*"
	}

	// MARK: - Inits

	init(nodes: [CommonMarkNode]) {
		self.nodes = nodes
	}
}
