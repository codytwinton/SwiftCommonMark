//
//  CommonMarkParseableTests.swift
//  SwiftCommonMarkTests
//
//  Created by Cody Winton on 3/4/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

@testable import SwiftCommonMark
import XCTest

// MARK: -

class CommonMarkParseableTests: XCTestCase {

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

	// MARK: - Custom Functions

	@discardableResult
	func testViolations(for section: CommonMarkTestSection) -> Int {
		let tests = commonMarkTests.filter { $0.section == section.rawValue }
		var violations = 0

		print("\n********\n\n")

		for test in tests {
			let actual: String = Node.parseDocument(markdown: test.markdown).html
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

	// MARK: - Tests

	/*
	func testSection() {
		testViolations(for: .thematicBreak)
	}

	func testStatic() {
		let input = "**Testing *test* What**\n"
		let expected = "<strong>Testing <em>test</em> What</strong>\n"
		let node = Node.parseDocument(markdown: input)

		let actual = node.html

		XCTAssertEqual(actual, expected)

		guard actual != expected else { return }
		print("\n********\n\n" +
			"Failed:" +
			"\nMarkdown: \(input)" +
			"\nExpected: \(expected)" +
			"\nActual: \(actual)" +
			"\n********\n\n")
	}

	func testAllSectionViolations() {
		print("All sections tests: \(commonMarkTests.count)")

		var violations = 0
		for section in CommonMarkTestSection.all {
			violations += testViolations(for: section)
		}

		print("Violations: \(violations)/\(commonMarkTests.count)")
	}
	*/
}
