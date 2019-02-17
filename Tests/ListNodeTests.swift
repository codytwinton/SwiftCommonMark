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
        return ListNode(listType: .asterisk, nodes: [item1, item2])
    }()

    let uList2: ListNode = {
        let item1 = ListItemNode(nodes: [ParagraphNode(nodes: [TextNode("Second")])])
        return ListNode(listType: .plus, nodes: [item1])
    }()

    let uList3: ListNode = {
        let item1 = ListItemNode(nodes: [ParagraphNode(nodes: [TextNode("Unordered")])])
        let item2 = ListItemNode(nodes: [ParagraphNode(nodes: [TextNode("Loose")])])
        return ListNode(listType: .dash, isTight: false, nodes: [item1, item2])
    }()

    let oList1: ListNode = {
        let item1 = ListItemNode(nodes: [ParagraphNode(nodes: [TextNode("Ordered")])])
        let item2 = ListItemNode(nodes: [ParagraphNode(nodes: [TextNode("List")])])
        return ListNode(listType: .period(start: 2), nodes: [item1, item2])
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

    func testHTML() {
        let expecteds = ["<ul>\n<li>Unordered</li>\n<li>List</li>\n</ul>\n",
                         "<ul>\n<li>Second</li>\n</ul>\n",
                         "<ul>\n<li>\n<p>Unordered</p>\n</li>\n<li>\n<p>Loose</p>\n</li>\n</ul>\n",
                         "<ol start=\"2\">\n<li>Ordered</li>\n<li>List</li>\n</ol>\n",
                         "<ol>\n<li>\n<p>Ordered</p>\n</li>\n<li>\n<p>Loose</p>\n</li>\n</ol>\n"]

        for (index, node) in [uList1, uList2, uList3, oList1, oList2].enumerated() {
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
        let expecteds = ["* Unordered\n* List\n\n",
                         "+ Second\n\n",
                         "- Unordered\n\n- Loose\n\n",
                         "2. Ordered\n3. List\n\n",
                         "1) Ordered\n\n2) Loose\n\n"]

        for (index, node) in [uList1, uList2, uList3, oList1, oList2].enumerated() {
            let actual = node.commonMark
            let expected = expecteds[index]

            XCTAssertEqual(expected, actual, "\n\n\n\n********\n\n" +
                "Failed CommonMark:" +
                "\n\nExpected: |\(expected)|" +
                "\n\nActual: |\(actual)|" +
                "\n********\n\n\n\n\n\n")
        }
    }

    // MARK: ListType Tests

    func testListTypes() {
        let types: [ListType] = [.dash, .asterisk, .plus, .period(start: 1), .paren(start: 2)]
        XCTAssertEqual(types.count, 5)

        let htmlPrefixs: [String] = ["<ul>", "<ul>", "<ul>", "<ol>", "<ol start=\"2\">"]
        let htmlPostfixs: [String] = ["</ul>", "</ul>", "</ul>", "</ol>", "</ol>"]
        let commonMarkDelimiters: [String] = ["-", "*", "+", ".", ")"]

        for (index, type) in types.enumerated() {
            XCTAssertEqual(type.htmlPrefix, htmlPrefixs[index])
            XCTAssertEqual(type.htmlPostfix, htmlPostfixs[index])
            XCTAssertEqual(type.commonMarkDelimiter, commonMarkDelimiters[index])
        }
    }
}
