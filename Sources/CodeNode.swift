//
//  CodeNode.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/23/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: -

struct CodeNode: CommonMarkNode {

	// MARK: Constants

	let type: NodeType = .code

	// MARK: Variables

	private(set) var code: String

	// MARK: - HTMLRenderable

	var html: String {
		return "<code>" + code + "</code>"
	}

	// MARK: - CommonMarkRenderable

	var commonMark: String {
		return "`" + code.trimmingCharacters(in: .whitespacesAndNewlines) + "`"
	}
}
