//
//  CommonMarkParsable.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/8/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: - Protocols

protocol CommonMarkParsable {
	static func parseDocument(markdown: String) -> CommonMark
}

// MARK: - Extensions

extension Node: CommonMarkParsable {

	static func parseDocument(markdown: String) -> CommonMark {
		let nodes = NodeType.document.parse(markdown: markdown)
		return self.document(nodes: nodes)
	}
}
