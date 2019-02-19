//
//  ListItemNodeTests.swift
//  SwiftCommonMarkTests
//
//  Created by Cody Winton on 3/24/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

@testable import SwiftCommonMark
import XCTest

// MARK: -

internal class ListItemNodeTests: XCTestCase {
  // MARK: Constants

  let node: Node = .listItem([.paragraph([.text("List")])])

  // MARK: HeadingNode Tests

  func testTypes() {
    XCTAssertEqual(node.type, .listItem)
  }

  func testHTML() {
    let actual = node.html
    let expected = "<li><p>List</p>\n</li>\n"

    XCTAssertEqual(
      expected,
      actual,
      "\n\n\n\n********\n\n" +
        "Failed HTML:" +
        "\n\nExpected: |\(expected)|" +
        "\n\nActual: |\(actual)|" +
      "\n********\n\n\n\n\n\n"
    )
  }

  func testCommonMark() {
    let actual = node.commonMark
    let expected = "List\n\n\n"

    XCTAssertEqual(
      expected,
      actual,
      "\n\n\n\n********\n\n" +
        "Failed CommonMark:" +
        "\n\nExpected: |\(expected)|" +
        "\n\nActual: |\(actual)|" +
      "\n********\n\n\n\n\n\n"
    )
  }
}
