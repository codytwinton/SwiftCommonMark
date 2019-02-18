//
//  HTMLEnumNodeTests.swift
//  SwiftCommonMarkTests
//
//  Created by Cody Winton on 3/24/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

@testable import SwiftCommonMark
import XCTest

// MARK: -

internal class HTMLEnumNodeTests: XCTestCase {
  let inline: CommonMarkAST = .htmlInline("<bab>")
  let block: CommonMarkAST = .htmlBlock("""
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
    let expecteds = [
      "<bab>",
      """
      <table>
      <tr>
      <td>hi</td>
      </tr>
      </table>

      """
    ]

    for (index, node) in [inline, block].enumerated() {
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
      "<bab>",
      """
      <table>
      <tr>
      <td>hi</td>
      </tr>
      </table>


      """
    ]

    for (index, node) in [inline, block].enumerated() {
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
