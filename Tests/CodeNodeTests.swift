//
//  CodeNodeTests.swift
//  SwiftCommonMarkTests
//
//  Created by Cody Winton on 3/24/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

@testable import SwiftCommonMark
import XCTest

// MARK: -

internal class CodeNodeTests: XCTestCase {
  let inline: Node = .codeInline("Testing Code")
  let blockNoInfo: Node = .codeBlock(info: nil, "Testing Code\n")
  let blockInfo: Node = .codeBlock(info: "info", "Testing Code\n")

  func testTypes() {
    XCTAssertEqual(inline.type, .codeInline)
    XCTAssertEqual(blockNoInfo.type, .codeBlock)
    XCTAssertEqual(blockInfo.type, .codeBlock)
  }

  func testHTML() {
    let expecteds = [
      "<code>Testing Code</code>",
      "<pre><code>Testing Code\n</code></pre>\n",
      "<pre><code class=\"language-info\">Testing Code\n</code></pre>\n"
    ]

    for (index, node) in [inline, blockNoInfo, blockInfo].enumerated() {
      let actual = node.html
      let expected = expecteds[index]

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
  }

  func testCommonMark() {
    let expecteds = [
      "`Testing Code`",
      "```\nTesting Code\n```\n\n",
      "```info\nTesting Code\n```\n\n"
    ]

    for (index, node) in [inline, blockNoInfo, blockInfo].enumerated() {
      let actual = node.commonMark
      let expected = expecteds[index]

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
}
