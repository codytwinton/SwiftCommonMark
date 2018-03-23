//
//  HTMLNode.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/23/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: -

struct HTMLNode: HTMLRenderable, CommonMarkRenderable {

	// MARK: Variables

	private var content: String
	private var isInline: Bool

	private var type: NodeType {
		return isInline ? .htmlInline : .htmlBlock
	}

	// MARK: - HTMLRenderable

	var html: String {
		return content + ( isInline ? "" : "\n" )
	}

	// MARK: - CommonMarkRenderable

	var commonMark: String {
		return content + ( isInline ? "" : "\n\n" )
	}
}
