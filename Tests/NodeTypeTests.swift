//
//  NodeTypeTests.swift
//  SwiftCommonMarkTests
//
//  Created by Cody Winton on 3/14/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

@testable import SwiftCommonMark
import XCTest

internal class NodeTypeTests: XCTestCase {
  func testNodeTypes() {
    XCTAssertEqual(
      NodeType.allCases,
      [
        .blockQuote,
        .codeBlock,
        .codeInline,
        .document,
        .emphasis,
        .heading,
        .htmlBlock,
        .htmlInline,
        .image,
        .lineBreak,
        .link,
        .list,
        .listItem,
        .paragraph,
        .softBreak,
        .strong,
        .text,
        .thematicBreak
      ]
    )
  }
}
