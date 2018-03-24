//
//  BlockQuoteNodeTests.swift
//  SwiftCommonMarkTests
//
//  Created by Cody Winton on 3/24/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

@testable import SwiftCommonMark
import XCTest

class BlockQuoteNodeTests: XCTestCase {

	let node: BlockQuoteNode = {
		let text1 = TextNode("Test Blockquote")
		let text2 = TextNode("Testing Blockquote")
		return BlockQuoteNode(nodes: [ParagraphNode(nodes: [text1]), ParagraphNode(nodes: [text2])])
	}()

	func testTypes() {
		XCTAssertEqual(node.type, .blockQuote)
	}

	func testHTML() {
		let actual = node.html
		let expected = """
			<blockquote>
			<p>Test Blockquote</p>
			<p>Testing Blockquote</p>
			</blockquote>

			"""

		XCTAssertEqual(expected, actual, "\n\n\n\n********\n\n" +
			"Failed:" +
			"\n\nExpected: |\(expected)|" +
			"\n\nActual: |\(actual)|" +
			"\n********\n\n\n\n\n\n")
	}

	func testCommonMark() {
		let actual = node.commonMark
		let expected = """
			> Test Blockquote
			>
			> Testing Blockquote


			"""

		XCTAssertEqual(expected, actual, "\n\n\n\n********\n\n" +
			"Failed:" +
			"\n\nExpected: |\(expected)|" +
			"\n\nActual: |\(actual)|" +
			"\n********\n\n\n\n\n\n")
	}
}
