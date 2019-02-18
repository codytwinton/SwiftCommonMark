//
//  HeadingEnumNodeTests.swift
//  SwiftCommonMarkTests
//
//  Created by Cody Winton on 3/24/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

@testable import SwiftCommonMark
import XCTest

// MARK: -

internal class HeadingEnumNodeTests: XCTestCase {
  // MARK: Constants

  let node: CommonMarkAST = {
    let text1: CommonMarkAST = .text("Hello World")
    return CommonMarkAST.heading(.h1, [text1])
  }()

  // MARK: Type Tests

  func testTypes() {
    XCTAssertEqual(node.type, .heading)
  }

  // MARK: Render Tests

  func testHTML() {
    let actual = node.html
    let expected = """
      <h1>Hello World</h1>

      """

    XCTAssertEqual(expected, actual)
  }

  func testCommonMark() {
    let actual = node.commonMark
    let expected = """
      # Hello World


      """

    XCTAssertEqual(expected, actual)
  }

  // MARK: - Parsing Tests

  func testBlockParse() {
    let shouldNotParse: [String] = [
      "####### foo",
      "#5 bolt",
      "#hashtag",
      "\\## foo",
      "    # foo"
    ]

    for line in shouldNotParse {
      XCTAssertNil(CommonMarkAST(headingBlockLine: line))
    }

    let shouldParse: [String: CommonMarkAST] = [
      "# foo": .heading(.h1, [.text("foo")]),
      "## foo": .heading(.h2, [.text("foo")]),
      "### foo": .heading(.h3, [.text("foo")]),
      "#### foo": .heading(.h4, [.text("foo")]),
      "##### foo": .heading(.h5, [.text("foo")]),
      "###### foo": .heading(.h6, [.text("foo")]),
      "# foo *bar* \\*baz\\*": .heading(.h1, [.text("foo *bar* \\*baz\\*")]),
      "#                  foo             ": .heading(.h1, [.text("foo")]),
      " ### foo": .heading(.h3, [.text("foo")]),
      "  ## foo": .heading(.h2, [.text("foo")]),
      "   # foo": .heading(.h1, [.text("foo")]),
      "## foo ##": .heading(.h2, [.text("foo")]),
      "  ###   bar    ###": .heading(.h3, [.text("bar")]),
      "# foo ##################": .heading(.h1, [.text("foo")]),
      "##### foo ##": .heading(.h5, [.text("foo")]),
      "### foo ###     ": .heading(.h3, [.text("foo")]),
      "### foo ### b": .heading(.h3, [.text("foo ### b")]),
      "# foo#": .heading(.h1, [.text("foo#")]),
      "### foo \\###": .heading(.h3, [.text("foo ###")]),
      "## foo #\\##": .heading(.h2, [.text("foo ###")]),
      "# foo \\#": .heading(.h1, [.text("foo #")]),
      "## ": .heading(.h2, []),
      "#": .heading(.h1, []),
      "### ###": .heading(.h3, [])
    ]

    for (line, node) in shouldParse {
      XCTAssertEqual(node, CommonMarkAST(headingBlockLine: line))
    }
  }

  // MARK: HeadingLevel Tests

  func testHeadingLevels() {
    let levels: [HeadingLevel] = [.h1, .h2, .h3, .h4, .h5, .h6]
    XCTAssertEqual(HeadingLevel.allCases, levels)

    for (index, level) in levels.enumerated() {
      XCTAssertEqual(level.rawValue, index + 1)
    }
  }
}
