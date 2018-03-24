//
//  HTMLNodeTests.swift
//  SwiftCommonMarkTests
//
//  Created by Cody Winton on 3/24/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

@testable import SwiftCommonMark
import XCTest

// MARK: -

class HTMLNodeTests: XCTestCase {

	let inline: HTMLNode = .inline("<bab>")
	let block: HTMLNode = .block("""
	<table>
	<tr>
	<td>hi</td>
	</tr>
	</table>
	""")

	func testTypes() {
		XCTAssertEqual(inline.type, .htmlInline)
		XCTAssertEqual(block.type, .htmlBlock)
	}

	func testHTML() {
		let expecteds = ["<bab>",
						 """
						<table>
						<tr>
						<td>hi</td>
						</tr>
						</table>

						"""]

		for (i, node) in [inline, block].enumerated() {
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
		let expecteds = ["<bab>",
						 """
						<table>
						<tr>
						<td>hi</td>
						</tr>
						</table>


						"""]

		for (i, node) in [inline, block].enumerated() {
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
