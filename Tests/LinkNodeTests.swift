//
//  LinkNodeTests.swift
//  SwiftCommonMarkTests
//
//  Created by Cody Winton on 3/24/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

@testable import SwiftCommonMark
import XCTest

// MARK: -

class LinkNodeTests: XCTestCase {

	let node1: LinkNode = LinkNode(url: "/uri", title: "title", nodes: [TextNode("link")])
	let node2: LinkNode = LinkNode(url: "/uri")

	func testTypes() {
		XCTAssertEqual(node1.type, .link)
		XCTAssertEqual(node2.type, .link)
	}

	func testHTML() {
		let expecteds = ["<a href=\"/uri\" title=\"title\">link</a>",
						 "<a href=\"/uri\"></a>"]

		for (index, node) in [node1, node2].enumerated() {
			let actual = node.html
			let expected = expecteds[index]

			XCTAssertEqual(expected, actual, "\n\n\n\n********\n\n" +
				"Failed HTML:" +
				"\n\nExpected: |\(expected)|" +
				"\n\nActual: |\(actual)|" +
				"\n********\n\n\n\n\n\n")
		}
	}

	func testCommonMark() {

		let expecteds = ["[link](/uri \"title\")", "[](/uri)"]

		for (index, node) in [node1, node2].enumerated() {
			let actual = node.commonMark
			let expected = expecteds[index]

			XCTAssertEqual(expected, actual, "\n\n\n\n********\n\n" +
				"Failed CommonMark:" +
				"\n\nExpected: |\(expected)|" +
				"\n\nActual: |\(actual)|" +
				"\n********\n\n\n\n\n\n")
		}
	}
}
