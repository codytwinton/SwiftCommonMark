//
//  LinkNode.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/23/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: -

struct LinkNode: HTMLRenderable, CommonMarkRenderable {

	// MARK: Constants

	let type: NodeType = .link

	// MARK: Variables

	private var url: String
	private var title: String?
	private var nodes: [CommonMark]

	// MARK: - HTMLRenderable

	var html: String {
		var link = "<a href=\"\(url)\""

		if let title = title, !title.isEmpty {
			link += " title=\"\(title)\""
		}

		return link + ">" + nodes.html + "</a>"
	}

	// MARK: - CommonMarkRenderable

	var commonMark: String {
		var srcTitle = ""

		if let title = title {
			srcTitle += " \"" + title + "\""
		}

		return "[\(nodes.commonMark)](\(url)\(srcTitle))"
	}
}
