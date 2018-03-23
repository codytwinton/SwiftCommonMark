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

	// MARK: Variables

	private var nodes: [CommonMark]

	// MARK: - HTMLRenderable

	var html: String {
		let content = nodes.map { $0.html }.joined()
		return "<blockquote>\n\(content)</blockquote>\n"
	}

	// MARK: - CommonMarkRenderable

	var commonMark: String {
		return nodes.map { "> " + $0.commonMark }.joined()
			.replacingOccurrences(of: "\n\n> ", with: "\n>\n> ")
	}
}
