//
//  ListNodeTests.swift
//  SwiftCommonMarkTests
//
//  Created by Cody Winton on 3/24/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

@testable import SwiftCommonMark
import XCTest

// MARK: -

class ListNodeTests: XCTestCase {

	// MARK: Constants

	let uList1: ListNode = {
		let item1 = ListItemNode(nodes: [ParagraphNode(nodes: [TextNode("Unordered")])])
		let item2 = ListItemNode(nodes: [ParagraphNode(nodes: [TextNode("List")])])
		return ListNode(listType: .asterisk, isTight: true, nodes: [item1, item2])
	}()

	let uList2: ListNode = {
		let item1 = ListItemNode(nodes: [ParagraphNode(nodes: [TextNode("Second")])])
		return ListNode(listType: .plus, isTight: true, nodes: [item1])
	}()

	let uList3: ListNode = {
		let item1 = ListItemNode(nodes: [ParagraphNode(nodes: [TextNode("Unordered")])])
		let item2 = ListItemNode(nodes: [ParagraphNode(nodes: [TextNode("Loose")])])
		return ListNode(listType: .dash, isTight: false, nodes: [item1, item2])
	}()

	let oList1: ListNode = {
		let item1 = ListItemNode(nodes: [ParagraphNode(nodes: [TextNode("Ordered")])])
		let item2 = ListItemNode(nodes: [ParagraphNode(nodes: [TextNode("List")])])
		return ListNode(listType: .period(start: 2), isTight: true, nodes: [item1, item2])
	}()

	let oList2: ListNode = {
		let item1 = ListItemNode(nodes: [ParagraphNode(nodes: [TextNode("Ordered")])])
		let item2 = ListItemNode(nodes: [ParagraphNode(nodes: [TextNode("Loose")])])
		return ListNode(listType: .paren(start: 1), isTight: false, nodes: [item1, item2])
	}()

	// MARK: LinkNode Tests

	func testTypes() {
		XCTAssertEqual(uList1.type, .list)
		XCTAssertEqual(uList2.type, .list)
		XCTAssertEqual(uList3.type, .list)
		XCTAssertEqual(oList1.type, .list)
		XCTAssertEqual(oList2.type, .list)
	}

	// MARK: ListType Tests

	func testListTypes() {
		let types: [ListType] = [.dash, .asterisk, .plus, .period(start: 1), .paren(start: 2)]
		XCTAssertEqual(types.count, 5)

		let htmlPrefixs: [String] = ["<ul>", "<ul>", "<ul>", "<ol>", "<ol start=\"2\">"]
		let htmlPostfixs: [String] = ["</ul>", "</ul>", "</ul>", "</ol>", "</ol>"]
		let commonMarkDelimiters: [String] = ["-", "*", "+", ".", ")"]

		for (i, type) in types.enumerated() {
			XCTAssertEqual(type.htmlPrefix, htmlPrefixs[i])
			XCTAssertEqual(type.htmlPostfix, htmlPostfixs[i])
			XCTAssertEqual(type.commonMarkDelimiter, commonMarkDelimiters[i])
		}
	}
}
