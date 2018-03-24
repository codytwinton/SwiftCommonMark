//
//  CodeBlockNode.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/23/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: -

struct CodeBlockNode: CommonMarkNode {

	// MARK: Constants

	let type: NodeType = .codeBlock

	// MARK: Variables

	private(set) var info: String?
	private(set) var code: String

	// MARK: - HTMLRenderable

	var html: String {
		switch info {
		case let info?:
			return "<pre><code class=\"language-\(info)\">\(code)</code></pre>\n"
		case nil:
			return "<pre><code>\(code)</code></pre>\n"
		}
	}

	// MARK: - CommonMarkRenderable

	var commonMark: String {
		let info = self.info ?? ""
		return "```\(info)\n" + code + "```\n\n"
	}
}
