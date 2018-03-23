//
//  HeadingNode.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/23/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: Enums

enum HeadingLevel: Int, EnumProtocol {
	case h1 = 1, h2, h3, h4, h5, h6
}

// MARK: -

struct HeadingNode: HTMLRenderable, CommonMarkRenderable {

	// MARK: Constants

	let type: NodeType = .heading

	// MARK: Variables

	private var level: HeadingLevel
	private var nodes: [CommonMark]

	// MARK: - HTMLRenderable

	var html: String {
		let content = nodes.map { $0.html }.joined()
		return "<\(level)>" + content + "</\(level)>\n"
	}

	// MARK: - CommonMarkRenderable

	var commonMark: String {
		let content = nodes.map { $0.commonMark }.joined()
		return String(repeating: "#", count: level.rawValue) + " " + content + "\n\n"
	}
}
