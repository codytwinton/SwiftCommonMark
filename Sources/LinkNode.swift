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

		let content = nodes.map { $0.html }.joined()
		return link + ">" + content + "</a>"
	}

	// MARK: - CommonMarkRenderable

	var commonMark: String {
		let content = nodes.map { $0.html }.joined()

		var srcTitle = ""

		if let title = title {
			srcTitle += " \"" + title + "\""
		}

		return "[\(content)](\(url)\(srcTitle))"
	}
}
