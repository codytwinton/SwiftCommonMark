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

	// MARK: HeadingNode Tests

	func testTypes() {
		XCTAssertEqual(node.type, .heading)
	}

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

	// MARK: HeadingLevel Tests

	func testHeadingLevels() {
		let levels: [HeadingLevel] = [.h1, .h2, .h3, .h4, .h5, .h6]
		XCTAssertEqual(HeadingLevel.allCases, levels)

		for (i, level) in levels.enumerated() {
			XCTAssertEqual(level.rawValue, i + 1)
		}
	}
}
