//
//  CodeNodeTests.swift
//  SwiftCommonMarkTests
//
//  Created by Cody Winton on 3/24/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

@testable import SwiftCommonMark
import XCTest

class CodeNodeTests: XCTestCase {

	let inline: CodeNode = .inline("Testing Code")
	let blockNoInfo: CodeNode = .block(info: nil, code: "Testing Code\n")
	let blockInfo: CodeNode = .block(info: "info", code: "Testing Code\n")

	func testTypes() {
		XCTAssertEqual(inline.type, .code)
		XCTAssertEqual(blockNoInfo.type, .codeBlock)
		XCTAssertEqual(blockInfo.type, .codeBlock)
	}

	func testHTML() {
		let expecteds = ["<code>Testing Code</code>",
						 "<pre><code>Testing Code\n</code></pre>\n",
						 "<pre><code class=\"language-info\">Testing Code\n</code></pre>\n"]

		for (i, node) in [inline, blockNoInfo, blockInfo].enumerated() {
			let actual = node.html
			let expected = expecteds[i]

			XCTAssertEqual(expected, actual, "\n\n\n\n********\n\n" +
				"Failed HTML:" +
				"\n\nExpected: |\(expected)|" +
				"\n\nActual: |\(actual)|" +
				"\n********\n\n\n\n\n\n")
		}
	}

	func testCommonMark() {

		let expecteds = ["`Testing Code`",
						 "```\nTesting Code\n```\n\n",
						 "```info\nTesting Code\n```\n\n"]

		for (i, node) in [inline, blockNoInfo, blockInfo].enumerated() {
			let actual = node.commonMark
			let expected = expecteds[i]

			XCTAssertEqual(expected, actual, "\n\n\n\n********\n\n" +
				"Failed CommonMark:" +
				"\n\nExpected: |\(expected)|" +
				"\n\nActual: |\(actual)|" +
				"\n********\n\n\n\n\n\n")
		}
	}
}
