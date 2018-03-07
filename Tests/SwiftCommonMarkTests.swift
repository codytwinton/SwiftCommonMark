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
			XCTAssertNil(error, "CommonMark test error: \(error)")
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

	@discardableResult
	func testViolations(for section: CommonMarkTestSection) -> Int {
		let tests = commonMarkTests.filter { $0.section == section.rawValue }
		var violations = 0

		print("\n********\n\n")

		for test in tests {
			let actual: String = CommonMarkParser(markdown: test.markdown).render()
			guard test.html != actual else { continue }
			print("Failed \(test.section) example: \(test.example):" +
				"\nMarkdown: |\(test.markdown)|" +
				"\nExpected: \(test.html)" +
				"\nActual: \(actual)" +
				"\n********\n\n")
			violations += 1
		}

		XCTAssertEqual(violations, 0, "\(section.rawValue) violations: \(violations) of \(tests.count)")
		return violations
	}

	func testSection() {
		testViolations(for: .thematicBreak)
	}

	func testStatic() {
		let input = "### foo \\###\n## foo #\\##\n# foo \\#\n"
		let expected = "<h3>foo ###</h3>\n<h2>foo ###</h2>\n<h1>foo #</h1>\n"
		let parser = CommonMarkParser(markdown: input)

		let actual = parser.render()

		XCTAssertEqual(actual, expected)

		guard actual != expected else { return }
		print("\n********\n\n" +
			"Failed:" +
			"\nMarkdown: \(input)" +
			"\nExpected: \(expected)" +
			"\nActual: \(actual)" +
			"\n********\n\n")
	}

	/*
	func testAllSectionViolations() {
		print("All sections tests: \(commonMarkTests.count)")

		var violations = 0
		for section in CommonMarkTestSection.all {
			violations += testViolations(for: section)
		}

		print("Violations: \(violations)/\(commonMarkTests.count)")
	}
	*/

	func testAllSectionsExist() {
		let sections = CommonMarkTestSection.all

		XCTAssertEqual(commonMarkTestSections.count, CommonMarkTestSection.all.count)

		for section in sections {
			XCTAssert(commonMarkTestSections.contains(section.rawValue))
		}
	}
}
