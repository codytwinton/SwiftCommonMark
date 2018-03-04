//
//  SwiftCommonMarkTests.swift
//  SwiftCommonMarkTests
//
//  Created by Cody Winton on 3/4/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

import XCTest
@testable import SwiftCommonMark

class SwiftCommonMarkTests: XCTestCase {
	let markdown = CommonMark()
	var commonMarkTests: [CommonMarkTest] = []
    
    override func setUp() {
        super.setUp()

		let path = Bundle(for: type(of: self)).path(forResource: "commonmark-tests-spec", ofType: "json")
		XCTAssertNotNil(path)

		do {
			let jsonData = try String(contentsOfFile: path!, encoding: .utf8).data(using: .utf8)
			XCTAssertNotNil(jsonData)
			commonMarkTests = try JSONDecoder().decode([CommonMarkTest].self, from: jsonData!)
		} catch {
			XCTAssertNil(error, "error: \(error)")
		}
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
	func testCommonMarkParsing() {
		XCTAssertFalse(commonMarkTests.isEmpty)

		for test in commonMarkTests {
			let actual: String = markdown.parse(test.markdown)
			XCTAssertEqual(actual, test.html, "Failed Test \(test.example): \(test.section)")
		}
	}
}
