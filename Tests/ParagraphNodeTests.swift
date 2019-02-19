//
//  ParagraphNodeTests.swift
//  SwiftCommonMarkTests
//
//  Created by Cody Winton on 3/24/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

@testable import SwiftCommonMark
import XCTest

// MARK: -

internal class ParagraphNodeTests: XCTestCase {
  // MARK: Constants

  let node: CommonMarkAST = .paragraph([.text("Testing Paragraph")])

  // MARK: HeadingNode Tests

  func testTypes() {
    XCTAssertEqual(node.type, .paragraph)
  }

  func testHTML() {
    let actual = node.html
    let expected = """
      <p>Testing Paragraph</p>

      """

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
    let expected = """
      Testing Paragraph


      """

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
