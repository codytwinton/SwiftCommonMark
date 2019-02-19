//
//  BreakNodeTests.swift
//  SwiftCommonMarkTests
//
//  Created by Cody Winton on 3/24/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

@testable import SwiftCommonMark
import XCTest

// MARK: -

internal class BreakNodeTests: XCTestCase {
  // MARK: Constants

  let lineBreak: CommonMarkAST = .lineBreak
  let softBreak: CommonMarkAST = .softBreak
  let thematicBreak: CommonMarkAST = .thematicBreak

  // MARK: - Type Tests

  func testTypes() {
    XCTAssertEqual(lineBreak.type, .lineBreak)
    XCTAssertEqual(softBreak.type, .softBreak)
    XCTAssertEqual(thematicBreak.type, .thematicBreak)
  }

  // MARK: Render Tests

  func testHTML() {
    XCTAssertEqual(lineBreak.html, "<br />\n")
    XCTAssertEqual(softBreak.html, "\n")
    XCTAssertEqual(thematicBreak.html, "<hr />\n")
  }

  func testCommonMark() {
    XCTAssertEqual(lineBreak.commonMark, "\\\n")
    XCTAssertEqual(softBreak.commonMark, "\n")
    XCTAssertEqual(thematicBreak.commonMark, "***\n\n")
  }

  // MARK: - Parsing Tests

  func testBlockParse() {
    let shouldNotParse = [
      "+++",
      "===",
      "--",
      "**",
      "__",
      "    ***",
      "_ _ _ _ a",
      "a------",
      "---a---",
      " *-*"
    ]

    for line in shouldNotParse {
      XCTAssertNil(CommonMarkAST(breakBlockLine: line))
    }
  }

  func testThematicBreakParse() {
    let shouldParse = [
      "***",
      "---",
      "___",
      " ***",
      "  ***",
      "   ***",
      "_____________________________________",
      " - - -",
      " **  * ** * ** * **",
      "-     -      -      -",
      "- - - -    "
    ]

    for line in shouldParse {
      XCTAssertEqual(.thematicBreak, CommonMarkAST(breakBlockLine: line))
    }
  }
}
