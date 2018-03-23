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

struct ImageNode: HTMLRenderable, CommonMarkRenderable {

	// MARK: Constants

	let type: NodeType = .image

	// MARK: Variables

	private var source: String
	private var title: String?
	private var alternate: String

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
