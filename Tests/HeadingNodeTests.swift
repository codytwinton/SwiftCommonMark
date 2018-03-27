//
//  HeadingNodeTests.swift
//  SwiftCommonMarkTests
//
//  Created by Cody Winton on 3/24/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

@testable import SwiftCommonMark
import XCTest

// MARK: -

class HeadingNodeTests: XCTestCase {

	// MARK: Constants

	let node: HeadingNode = {
		let text1 = TextNode("Hello World")
		return HeadingNode(level: .h1, nodes: [text1])
	}()

	// MARK: Type Tests

	func testTypes() {
		XCTAssertEqual(node.type, .heading)
	}

	// MARK: Render Tests

	func testHTML() {
		let actual = node.html
		let expected = """
			<h1>Hello World</h1>

			"""

		XCTAssertEqual(expected, actual, "\n\n\n\n********\n\n" +
			"Failed HTML:" +
			"\n\nExpected: |\(expected)|" +
			"\n\nActual: |\(actual)|" +
			"\n********\n\n\n\n\n\n")
	}

	func testCommonMark() {
		let actual = node.commonMark
		let expected = """
			# Hello World


			"""

		XCTAssertEqual(expected, actual, "\n\n\n\n********\n\n" +
			"Failed CommonMark:" +
			"\n\nExpected: |\(expected)|" +
			"\n\nActual: |\(actual)|" +
			"\n********\n\n\n\n\n\n")
	}

	// MARK: - Parsing Tests

	func testBlockParse() {
		let shouldNotParse: [String] = [
			"####### foo",
			"#5 bolt",
			"#hashtag",
			"\\## foo",
			"    # foo"
		]

		for line in shouldNotParse {
			testBlockParse(for: line, expected: nil)
		}

		let shouldParse: [String] = [
			"# foo",
			"## foo",
			"### foo",
			"#### foo",
			"##### foo",
			"###### foo",
			"# foo *bar* \\*baz\\*",
			"#                  foo                     ",
			" ### foo",
			"  ## foo",
			"   # foo",
			"## foo ##",
			"  ###   bar    ###"
		]

		let parseHeadings: [HeadingNode] = [
			HeadingNode(level: .h1, nodes: [TextNode("foo")]),
			HeadingNode(level: .h2, nodes: [TextNode("foo")]),
			HeadingNode(level: .h3, nodes: [TextNode("foo")]),
			HeadingNode(level: .h4, nodes: [TextNode("foo")]),
			HeadingNode(level: .h5, nodes: [TextNode("foo")]),
			HeadingNode(level: .h6, nodes: [TextNode("foo")]),
			HeadingNode(level: .h1, nodes: [TextNode("foo *bar* \\*baz\\*")]),
			HeadingNode(level: .h1, nodes: [TextNode("foo")]),
			HeadingNode(level: .h3, nodes: [TextNode("foo")]),
			HeadingNode(level: .h2, nodes: [TextNode("foo")]),
			HeadingNode(level: .h1, nodes: [TextNode("foo")]),
			HeadingNode(level: .h2, nodes: [TextNode("foo")]),
			HeadingNode(level: .h3, nodes: [TextNode("bar")])
		]

		for (i, line) in shouldParse.enumerated() {
			let node = parseHeadings[i]
			testBlockParse(for: line, expected: node)
		}
	}

	func testBlockParse(for line: String, expected: HeadingNode?) {
		let actual = HeadingNode(blockLine: line)
		XCTAssertEqual(expected, actual, "\n\n\n\n********\n\n" +
			"Failed Thematic Break Parse for |\(line)|:" +
			"\n\nExpected: |\(String(describing: expected))|" +
			"\n\nActual: |\(String(describing: actual))|" +
			"\n********\n\n\n\n\n\n")
	}

	// MARK: HeadingLevel Tests

	func testHeadingLevels() {
		let levels: [HeadingLevel] = [.h1, .h2, .h3, .h4, .h5, .h6]
		XCTAssertEqual(HeadingLevel.allCases, levels)

		for (i, level) in levels.enumerated() {
			XCTAssertEqual(level.rawValue, i + 1)
		}
	}
}
