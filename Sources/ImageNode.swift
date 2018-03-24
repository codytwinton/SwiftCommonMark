//
//  ImageNode.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/23/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: -

struct ImageNode: CommonMarkNode {

	// MARK: Constants

	let type: NodeType = .image

	// MARK: Variables

	private(set) var source: String
	private(set) var title: String?
	private(set) var alternate: String

	// MARK: - HTMLRenderable

	var html: String {
		var image = "<img src=\"\(source)\" alt=\"\(alternate)\" "

		if let title = title, !title.isEmpty {
			image += "title=\"\(title)\" "
		}

		return image + "/>"
	}

	// MARK: - CommonMarkRenderable

	var commonMark: String {
		var srcTitle = ""

		if let title = title {
			srcTitle += " \"" + title + "\""
		}

		return "![\(alternate)](\(source)\(srcTitle))"
	}
}
