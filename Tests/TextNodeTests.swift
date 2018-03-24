//
//  TextNodeTests.swift
//  SwiftCommonMarkTests
//
//  Created by Cody Winton on 3/24/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

@testable import SwiftCommonMark
import XCTest

// MARK: -

class TextNodeTests: XCTestCase {

	let node: TextNode = TextNode("Testing <>\"")

	func testTypes() {
		XCTAssertEqual(node.type, .text)
	}

	func testHTML() {
		let actual = node.html
		let expected = "Testing &lt;&gt;&quot;"

		XCTAssertEqual(expected, actual, "\n\n\n\n********\n\n" +
			"Failed HTML:" +
			"\n\nExpected: |\(expected)|" +
			"\n\nActual: |\(actual)|" +
			"\n********\n\n\n\n\n\n")
	}

	func testCommonMark() {
		let actual = node.commonMark
		let expected = "Testing <>\""

		XCTAssertEqual(expected, actual, "\n\n\n\n********\n\n" +
			"Failed CommonMark:" +
			"\n\nExpected: |\(expected)|" +
			"\n\nActual: |\(actual)|" +
			"\n********\n\n\n\n\n\n")
	}
}
