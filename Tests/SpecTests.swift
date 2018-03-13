//
//  SpecTests.swift
//  SwiftCommonMarkTests
//
//  Created by Cody Winton on 3/10/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

import XCTest

// MARK: -

class SpecTests: XCTestCase {

	// MARK: Variables

	lazy var commonMarkTests: [CommonMarkSpecTest] = {
		guard let path = Bundle(for: type(of: self)).path(forResource: "commonmark-tests-spec-0.28", ofType: "json") else {
			XCTAssert(false, "CommonMark tests are nil")
			return []
		}
		do {
			let tests = try CommonMarkSpecTest.commonMarkTests(from: path)
			XCTAssertFalse(tests.isEmpty)
			return tests
		} catch {
			XCTAssertNil(error, "CommonMark test error: \(error)")
			return []
		}
	}()

	lazy var commonMarkTestSections: [String] = {
		var seen: Set<String> = []
		return self.commonMarkTests.filter { seen.update(with: $0.section) == nil }.map { $0.section }
	}()

	// MARK: - Tests

	func testAllSectionsExist() {
		let sections = CommonMarkTestSection.all

		XCTAssertEqual(commonMarkTestSections.count, CommonMarkTestSection.all.count)

		for section in sections {
			XCTAssert(commonMarkTestSections.contains(section.rawValue))
		}
	}
}
