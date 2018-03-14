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

	// MARK: - Custom Functions

	@discardableResult
	func testPasses(for section: CommonMarkTestSection) -> Int {
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

		let passes = tests.count - violations
		XCTAssertEqual(passes, tests.count, "\(section.rawValue) passes: \(passes) of \(tests.count)")
		return passes
	}

	// MARK: - Tests

	func testSection() {
		testPasses(for: .inlines)
		testPasses(for: .codeSpans)
		//testPasses(for: .softLineBreaks)
		//testPasses(for: .precedence)
		//testPasses(for: .blankLines)
	}

	/*
	func testStatic() {
		let input = "### foo \\###\n## foo #\\##\n# foo \\#\n"
		let expected = "<h3>foo ###</h3>\n<h2>foo ###</h2>\n<h1>foo #</h1>\n"
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
	*/

	/*
	func testAllSectionViolations() {
		var passes = 0
		for section in CommonMarkTestSection.all {
			passes += testPasses(for: section)
		}

		XCTAssertEqual(passes, commonMarkTests.count, "CommonMark Tests passes: \(passes) of \(commonMarkTests.count)")
	}
	*/
}
