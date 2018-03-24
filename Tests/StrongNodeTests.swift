//
//  StrongNodeTests.swift
//  SwiftCommonMarkTests
//
//  Created by Cody Winton on 3/24/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

@testable import SwiftCommonMark
import XCTest

// MARK: -

class StrongNodeTests: XCTestCase {

	// MARK: Constants

	let node: StrongNode = {
		let text1 = TextNode("Testing Strong")
		return StrongNode(nodes: [text1])
	}()

	// MARK: HeadingNode Tests

	func testTypes() {
		XCTAssertEqual(node.type, .strong)
	}

	func testHTML() {
		let actual = node.html
		let expected = "<strong>Testing Strong</strong>"

		XCTAssertEqual(expected, actual, "\n\n\n\n********\n\n" +
			"Failed HTML:" +
			"\n\nExpected: |\(expected)|" +
			"\n\nActual: |\(actual)|" +
			"\n********\n\n\n\n\n\n")
	}

	func testCommonMark() {
		let actual = node.commonMark
		let expected = "**Testing Strong**"

		XCTAssertEqual(expected, actual, "\n\n\n\n********\n\n" +
			"Failed CommonMark:" +
			"\n\nExpected: |\(expected)|" +
			"\n\nActual: |\(actual)|" +
			"\n********\n\n\n\n\n\n")
	}
}
