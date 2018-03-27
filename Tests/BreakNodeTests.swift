//
//  BreakNodeTests.swift
//  SwiftCommonMarkTests
//
//  Created by Cody Winton on 3/24/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

@testable import SwiftCommonMark
import XCTest

// MARK: -

class BreakNodeTests: XCTestCase {

	// MARK: Constants

	let lineBreak: BreakNode = .lineBreak
	let softBreak: BreakNode = .softBreak
	let thematicBreak: BreakNode = .thematicBreak

	// MARK: - Type Tests

    func testTypes() {
		XCTAssertEqual(lineBreak.type, .lineBreak)
		XCTAssertEqual(softBreak.type, .softBreak)
		XCTAssertEqual(thematicBreak.type, .thematicBreak)
    }

	// MARK: Render Tests

	func testHTML() {
		XCTAssertEqual(lineBreak.html, "<br />\n")
		XCTAssertEqual(softBreak.html, "\n")
		XCTAssertEqual(thematicBreak.html, "<hr />\n")
	}

	func testCommonMark() {
		XCTAssertEqual(lineBreak.commonMark, "\\\n")
		XCTAssertEqual(softBreak.commonMark, "\n")
		XCTAssertEqual(thematicBreak.commonMark, "***\n\n")
	}

	// MARK: - Parsing Tests

	func testBlockParse() {
		let shouldParse = [
			"***",
			"---",
			"___",
			" ***",
			"  ***",
			"   ***",
			"_____________________________________",
			" - - -",
			" **  * ** * ** * **",
			"-     -      -      -",
			"- - - -    "
		]

		for line in shouldParse {
			testBlockParse(for: line, expected: .thematicBreak)
		}

		let shouldNotParse = [
			"+++",
			"===",
			"--",
			"**",
			"__",
			"    ***",
			"_ _ _ _ a",
			"a------",
			"---a---",
			" *-*"
		]

		for line in shouldNotParse {
			testBlockParse(for: line, expected: nil)
		}
	}

	func testBlockParse(for line: String, expected: BreakNode?) {
		let actual = BreakNode(blockLine: line)
		XCTAssertEqual(expected, actual, "\n\n\n\n********\n\n" +
			"Failed Thematic Break Parse for |\(line)|:" +
			"\n\nExpected: |\(String(describing: expected))|" +
			"\n\nActual: |\(String(describing: actual))|" +
			"\n********\n\n\n\n\n\n")
	}
}
