//
//  HTMLRenderableTests.swift
//  SwiftCommonMarkTests
//
//  Created by Cody Winton on 3/10/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

@testable import SwiftCommonMark
import XCTest

// MARK: -

class HTMLRenderableTests: XCTestCase {

	// MARK: - Tests

    func testExample() {

		// Arrange

		let expected = """
		<p>Testing
		Testing now: <code>Testing Code</code></p>
		<hr />
		<p>What is up?<br />
		Testing</p>

		"""

		let text1 = Node.text("Testing")
		let text2 = Node.text("Testing now: ")
		let code1 = Node.code("Testing Code")

		let paragraph1 = Node.paragraph(nodes: [text1, .softBreak, text2, code1])

		let text3 = Node.text("What is up?")
		let text4 = Node.text("Testing")

		let paragraph2 = Node.paragraph(nodes: [text3, .lineBreak, text4])

		let doc: Node = .document(nodes: [paragraph1, .thematicBreak, paragraph2])

		// Act

		let actual = doc.html

		// Assert

		XCTAssertEqual(actual, expected)
    }
}
