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
    return CommonMarkAST.heading(level: .h1, nodes: [text1])
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
      XCTAssertEqual(nil, CommonMarkAST(blockLine: line))
    }

    let shouldParse: [String: CommonMarkAST] = [
      "# foo": .heading(level: .h1, nodes: [.text("foo")]),
      "## foo": .heading(level: .h2, nodes: [.text("foo")]),
      "### foo": .heading(level: .h3, nodes: [.text("foo")]),
      "#### foo": .heading(level: .h4, nodes: [.text("foo")]),
      "##### foo": .heading(level: .h5, nodes: [.text("foo")]),
      "###### foo": .heading(level: .h6, nodes: [.text("foo")]),
      "# foo *bar* \\*baz\\*": .heading(level: .h1, nodes: [.text("foo *bar* \\*baz\\*")]),
      "#                  foo             ": .heading(level: .h1, nodes: [.text("foo")]),
      " ### foo": .heading(level: .h3, nodes: [.text("foo")]),
      "  ## foo": .heading(level: .h2, nodes: [.text("foo")]),
      "   # foo": .heading(level: .h1, nodes: [.text("foo")]),
      "## foo ##": .heading(level: .h2, nodes: [.text("foo")]),
      "  ###   bar    ###": .heading(level: .h3, nodes: [.text("bar")]),
      "# foo ##################": .heading(level: .h1, nodes: [.text("foo")]),
      "##### foo ##": .heading(level: .h5, nodes: [.text("foo")]),
      "### foo ###     ": .heading(level: .h3, nodes: [.text("foo")]),
      "### foo ### b": .heading(level: .h3, nodes: [.text("foo ### b")]),
      "# foo#": .heading(level: .h1, nodes: [.text("foo#")]),
      "### foo \\###": .heading(level: .h3, nodes: [.text("foo ###")]),
      "## foo #\\##": .heading(level: .h2, nodes: [.text("foo ###")]),
      "# foo \\#": .heading(level: .h1, nodes: [.text("foo #")]),
      "## ": .heading(level: .h2, nodes: []),
      "#": .heading(level: .h1, nodes: []),
      "### ###": .heading(level: .h3, nodes: [])
    ]

    for (line, node) in shouldParse {
      XCTAssertEqual(node, CommonMarkAST(blockLine: line))
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
