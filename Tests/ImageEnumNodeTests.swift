//
//  ImageEnumNodeTests.swift
//  SwiftCommonMarkTests
//
//  Created by Cody Winton on 3/24/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

@testable import SwiftCommonMark
import XCTest

// MARK: -

internal class ImageEnumNodeTests: XCTestCase {
  let node1: CommonMarkAST = .image(source: "/url", title: "title", alternate: "foo")
  let node2: CommonMarkAST = .image(source: "/url", title: nil, alternate: "")

  func testTypes() {
    XCTAssertEqual(node1.type, .image)
    XCTAssertEqual(node2.type, .image)
  }

  func testHTML() {
    let expecteds = [
      "<img src=\"/url\" alt=\"foo\" title=\"title\" />",
      "<img src=\"/url\" alt=\"\" />"
    ]

    for (index, node) in [node1, node2].enumerated() {
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
    let expecteds = ["![foo](/url \"title\")", "![](/url)"]

    for (index, node) in [node1, node2].enumerated() {
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
