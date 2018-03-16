//
//  NodeTypeTests.swift
//  SwiftCommonMarkTests
//
//  Created by Cody Winton on 3/14/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

@testable import SwiftCommonMark
import XCTest

class NodeTypeTests: XCTestCase {

	func testHeadingLevels() {
		let levels: [HeadingLevel] = [.h1, .h2, .h3, .h4, .h5, .h6]
		XCTAssertEqual(HeadingLevel.allCases, levels)

		for (i, level) in levels.enumerated() {
			XCTAssertEqual(level.rawValue, i + 1)
		}
	}

    func testNodeTypes() {

		let nodeTypes: [NodeType] = [.blockQuote, .code, .codeBlock, .document, .emphasis, .heading,
									 .htmlBlock, .htmlInline, .image, .lineBreak, .link, .list,
									 .listItem, .paragraph, .softBreak, .strong, .text, .thematicBreak]
		XCTAssertEqual(NodeType.allCases, nodeTypes)

		let nodes: [Node] = [
			.blockQuote(nodes: []),
			.code(""),
			.codeBlock(info: nil, code: ""),
			.document(nodes: []),
			.emphasis(nodes: []),
			.heading(level: .h1, nodes: []),
			.htmlBlock(""),
			.htmlInline(""),
			.image(source: "", title: nil, alternate: ""),
			.lineBreak,
			.link(url: "", title: nil, nodes: []),
			.list(isOrdered: false, nodes: []),
			.listItem(nodes: []),
			.paragraph(nodes: []),
			.softBreak,
			.strong(nodes: []),
			.text(""),
			.thematicBreak
		]

		XCTAssertEqual(nodes.count, nodeTypes.count)

		for (i, node) in nodes.enumerated() {
			XCTAssertEqual(node.type, nodeTypes[i])
		}
    }
}
