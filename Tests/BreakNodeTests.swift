//
//  BreakNodeTests.swift
//  SwiftCommonMarkTests
//
//  Created by Cody Winton on 3/24/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

@testable import SwiftCommonMark
import XCTest

class BreakNodeTests: XCTestCase {

	let lineBreak: BreakNode = .lineBreak
	let softBreak: BreakNode = .softBreak
	let thematicBreak: BreakNode = .thematicBreak

    func testTypes() {
		XCTAssertEqual(lineBreak.type, .lineBreak)
		XCTAssertEqual(softBreak.type, .softBreak)
		XCTAssertEqual(thematicBreak.type, .thematicBreak)
    }

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
}
