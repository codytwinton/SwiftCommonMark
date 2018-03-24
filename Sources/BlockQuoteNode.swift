//
//  BlockQuoteNode.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/23/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: -

struct BlockQuoteNode: HTMLRenderable, CommonMarkRenderable {

	// MARK: Constants

	let type: NodeType = .blockQuote

	// MARK: Variables

	private var nodes: [CommonMark]

	// MARK: - HTMLRenderable

	var html: String {
		return "<blockquote>\n" + nodes.html + "</blockquote>\n"
	}

	// MARK: - CommonMarkRenderable

	var commonMark: String {
		return nodes.map { "> " + $0.commonMark }.joined()
			.replacingOccurrences(of: "\n\n> ", with: "\n>\n> ")
	}
}
