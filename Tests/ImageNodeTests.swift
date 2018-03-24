//
//  ImageNodeTests.swift
//  SwiftCommonMarkTests
//
//  Created by Cody Winton on 3/24/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

@testable import SwiftCommonMark
import XCTest

// MARK: -

class ImageNodeTests: XCTestCase {

	let node1: ImageNode = ImageNode(source: "/url", title: "title", alternate: "foo")
	let node2: ImageNode = ImageNode(source: "/url")

	func testTypes() {
		XCTAssertEqual(node1.type, .image)
		XCTAssertEqual(node2.type, .image)
	}

	func testHTML() {
		let expecteds = ["<img src=\"/url\" alt=\"foo\" title=\"title\" />",
						 "<img src=\"/url\" alt=\"\" />"]

		for (i, node) in [node1, node2].enumerated() {
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

		let expecteds = ["![foo](/url \"title\")", "![](/url)"]

		for (i, node) in [node1, node2].enumerated() {
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
