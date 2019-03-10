//
//  CommonMarkParseTests.swift
//  SwiftCommonMarkTests
//
//  Created by Cody Winton on 3/4/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

@testable import SwiftCommonMark
import XCTest

// MARK: -

internal class CommonMarkParseTests: XCTestCase {
  // MARK: Variables

  lazy var commonMarkTests: [CommonMarkSpecTest] = {
    guard let path = Bundle(for: type(of: self))
      .path(forResource: CommonMarkSpec.specName, ofType: CommonMarkSpec.specType) else {
        XCTAssert(false, "CommonMark tests are nil")
        return []
    }
    do {
      let spec = try CommonMarkSpec(path: path)
      XCTAssertFalse(spec.tests.isEmpty)
      return spec.tests
    } catch {
      XCTAssertNil(error, "CommonMark test error: \(error)")
      return []
    }
  }()

  // MARK: - Custom Functions

  @discardableResult
  func testPasses(for section: CommonMarkTestSection) -> Int {
    let tests = commonMarkTests.filter { $0.section == section.rawValue }
    var violations = 0

    print("\n********\n\n")

    for test in tests {
      let actual: String = NodeType.parseDocument(markdown: test.markdown).html
      guard test.html != actual else { continue }
      print(
        "Failed \(test.section) example: \(test.example):" +
          "\nMarkdown: |\(test.markdown)|" +
          "\nExpected: \(test.html)" +
          "\nActual: \(actual)" +
        "\n********\n\n"
      )
      violations += 1
    }

    let passes = tests.count - violations
    // XCTAssertEqual(passes, tests.count, "\(section.rawValue) passes: \(passes) of \(tests.count)")
    return passes
  }

  // MARK: - Tests

  func testAllSectionViolations() {
    var passes = 0
    for section in CommonMarkTestSection.allCases {
      passes += testPasses(for: section)
    }

    // XCTAssertEqual(passes, commonMarkTests.count, "CommonMark Tests passes: \(passes) of \(commonMarkTests.count)")
  }

  func testParsing() {
    let html = """
    <h1>Testing</h1>
    <hr />
    <p>Lorem ipsum dolor
    sit amet.</p>
    <p>Lorem ipsum dolor sit amet.</p>

    """

    let markdown = """
    # Testing

    ***

    Lorem ipsum dolor
    sit amet.

    Lorem ipsum dolor sit amet.

    """

    let document = NodeType.parseDocument(markdown: markdown)
    // XCTAssertEqual(document.html, html)
  }
}
