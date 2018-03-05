//
//  SwiftCommonMarkTests.swift
//  SwiftCommonMarkTests
//
//  Created by Cody Winton on 3/4/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

@testable import SwiftCommonMark
import XCTest

class SwiftCommonMarkTests: XCTestCase {

	lazy var commonMarkTests: [CommonMarkTest] = {
		guard let path = Bundle(for: type(of: self)).path(forResource: "commonmark-tests-spec", ofType: "json") else {
			XCTAssert(false, "CommonMark tests are nil")
			return []
		}
		do {
			let tests = try CommonMarkTest.commonMarkTests(from: path)
			XCTAssertFalse(tests.isEmpty)
			return tests
		} catch {
			XCTAssertNil(error, "CommonMark tests are nil")
			return []
		}
	}()

	lazy var commonMarkTestSections: [String] = {
		var seen: Set<String> = []
		return self.commonMarkTests.filter { seen.update(with: $0.section) == nil }.map { $0.section }
	}()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

	func checkViolations(for section: CommonMarkTestSection) -> Int {
		let tests = commonMarkTests.filter { $0.section == section.rawValue }
		var violations = 0

		for test in tests {
			let actual: String = CommonMarkParser(markdown: test.markdown).render()
			guard test.html != actual else { continue }
			print("Failed Test \(test.example): \(test.section)")
			violations += 1
		}

		return violations
	}

	func testSectionViolations() {
		for section in CommonMarkTestSection.all {
			let violations = checkViolations(for: section)
			XCTAssertEqual(violations, 0, "\(section.rawValue) has \(violations) violations")
		}
	}

	func testAllSectionsExist() {
		let sections = CommonMarkTestSection.all

		XCTAssertEqual(commonMarkTestSections.count, CommonMarkTestSection.all.count)

		for section in sections {
			XCTAssert(commonMarkTestSections.contains(section.rawValue))
		}
	}
}
