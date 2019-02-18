//
//  BlockQuoteEnumNodeTests.swift
//  SwiftCommonMarkTests
//
//  Created by Cody Winton on 3/24/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

@testable import SwiftCommonMark
import XCTest

internal class BlockQuoteEnumNodeTests: XCTestCase {
  let node: CommonMarkAST = {
    let text1: CommonMarkAST = .text("Test Blockquote")
    let text2: CommonMarkAST = .text("Testing Blockquote")
    return CommonMarkAST.blockQuote([.paragraph([text1]), .paragraph([text2])])
  }()

  func testTypes() {
    XCTAssertEqual(node.type, .blockQuote)
  }

  func testHTML() {
    let actual = node.html
    let expected = """
      <blockquote>
      <p>Test Blockquote</p>
      <p>Testing Blockquote</p>
      </blockquote>

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
      > Test Blockquote
      >
      > Testing Blockquote


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
