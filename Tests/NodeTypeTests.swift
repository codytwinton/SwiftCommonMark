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

	func testNodeTypes() {

		let nodeTypes: [NodeType] = [.blockQuote, .code, .codeBlock, .document, .emphasis, .heading,
									 .htmlBlock, .htmlInline, .image, .lineBreak, .link, .list,
									 .listItem, .paragraph, .softBreak, .strong, .text, .thematicBreak]
		XCTAssertEqual(NodeType.allCases, nodeTypes)
    }
}
