//
//  EmphasisNodeTests.swift
//  SwiftCommonMarkTests
//
//  Created by Cody Winton on 3/24/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

@testable import SwiftCommonMark
import XCTest

// MARK: -

class EmphasisNodeTests: XCTestCase {
    // MARK: Constants

    let node: EmphasisNode = {
        let text1 = TextNode("Testing Emphasis")
        return EmphasisNode(nodes: [text1])
    }()

    // MARK: HeadingNode Tests

    func testTypes() {
        XCTAssertEqual(node.type, .emphasis)
    }

    func testHTML() {
        let actual = node.html
        let expected = "<em>Testing Emphasis</em>"

        XCTAssertEqual(expected, actual, "\n\n\n\n********\n\n" +
            "Failed HTML:" +
            "\n\nExpected: |\(expected)|" +
            "\n\nActual: |\(actual)|" +
            "\n********\n\n\n\n\n\n")
    }

    func testCommonMark() {
        let actual = node.commonMark
        let expected = "*Testing Emphasis*"

        XCTAssertEqual(expected, actual, "\n\n\n\n********\n\n" +
            "Failed CommonMark:" +
            "\n\nExpected: |\(expected)|" +
            "\n\nActual: |\(actual)|" +
            "\n********\n\n\n\n\n\n")
    }
}
