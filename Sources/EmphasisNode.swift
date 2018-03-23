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

struct EmphasisNode: HTMLRenderable, CommonMarkRenderable {

	// MARK: Constants

	let type: NodeType = .emphasis

	// MARK: Variables

	private var nodes: [CommonMark]

	// MARK: - HTMLRenderable

	var html: String {
		return "<em>" + nodes.map { $0.html }.joined() + "</em>"
	}

	// MARK: - CommonMarkRenderable

	var commonMark: String {
		return "*" + nodes.map { $0.commonMark }.joined() + "*"
	}
}
