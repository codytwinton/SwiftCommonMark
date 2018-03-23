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

struct DocumentNode: HTMLRenderable, CommonMarkRenderable {

	// MARK: Constants

	let type: NodeType = .document

	// MARK: Variables

	private var nodes: [CommonMark]

	// MARK: - HTMLRenderable

	var html: String {
		return nodes.map { $0.html }.joined()
	}

	// MARK: - CommonMarkRenderable

	var commonMark: String {
		return nodes.map { "> " + $0.commonMark }.joined()
			.trimmingCharacters(in: .newlines) + "\n"
	}
}
