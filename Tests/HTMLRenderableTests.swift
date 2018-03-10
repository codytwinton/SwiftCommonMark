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

    func testNodeHTMLRendering() {

		// Arrange

		let expected = """
		<h1>Hello World</h1>
		<p>Testing
		Testing now: <code>Testing Code</code></p>
		<hr />
		<p>What <strong>is</strong> <em>up</em>?<br />
		Testing</p>
		<pre><code>Testing
		</code></pre>
		<pre><code class="language-swift">Testing 123
		</code></pre>

		"""

		let heading: Node = {
			let text1 = Node.text("Hello World")
			return Node.heading(level: .h1, nodes: [text1])
		}()

		let paragraph1: Node = {
			let text1 = Node.text("Testing")
			let text2 = Node.text("Testing now: ")
			let code1 = Node.code("Testing Code")
			return .paragraph(nodes: [text1, .softBreak, text2, code1])
		}()

		let paragraph2: Node = {
			let text1 = Node.text("What ")
			let strong1 = Node.strong(nodes: [.text("is")])
			let text2 = Node.text(" ")
			let emphasis1 = Node.emphasis(nodes: [.text("up")])
			let text3 = Node.text("?")
			let text4 = Node.text("Testing")

			return .paragraph(nodes: [text1, strong1, text2, emphasis1, text3, .lineBreak, text4])
		}()

		let code1 = Node.codeBlock(language: nil, code: "Testing\n")
		let code2 = Node.codeBlock(language: "swift", code: "Testing 123\n")

		let doc: Node = .document(nodes: [heading, paragraph1, .thematicBreak, paragraph2, code1, code2])

		// Act

		let actual = doc.html

		// Assert

		XCTAssertEqual(actual, expected)
    }
}
