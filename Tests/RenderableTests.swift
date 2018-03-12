//
//  RenderableTests.swift
//  SwiftCommonMarkTests
//
//  Created by Cody Winton on 3/10/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

@testable import SwiftCommonMark
import XCTest

// MARK: -

class RenderableTests: XCTestCase {

	// MARK: Variables

	let expectedHTML: String = """
		<h1>Hello World</h1>
		<p>Testing &lt;&gt;&quot;
		Testing now: <code>Testing Code</code></p>
		<hr />
		<p>What <strong>is</strong> <em>up</em>?<br />
		Testing</p>
		<pre><code>Testing
		</code></pre>
		<pre><code class="language-swift">Testing 123
		</code></pre>
		<blockquote>
		<p>Test Blockquote</p>
		</blockquote>
		<p><img src="/url" alt="foo" title="title" />
		<img src="/url" alt="" /></p>
		<ul>
		<li>Unordered</li>
		<li>List</li>
		</ul>
		<ol>
		<li>Ordered</li>
		<li>List</li>
		</ol>
		<p><a href="/uri" title="title">link</a>
		<a href="/uri"></a></p>
		<table>
		<tr>
		<td>hi</td>
		</tr>
		</table>
		<p><a><bab><c2c></p>

		"""

	let expectedCommonMark: String = """
		# Hello World
		Testing <>"
		Testing now: `Testing Code`
		***
		What **is** *up*?
		Testing

		```
		Testing
		```

		```swift
		Testing 123
		```

		> Test Blockquote

		![foo](/url "title")
		![](/url)

		* Unordered
		* List

		1. Ordered
		2. List

		[link](/uri "title")
		[](/uri)

		<table>
		<tr>
		<td>hi</td>
		</tr>
		</table>

		<a><bab><c2c>

		"""

	let nodeTree: Node = {
		let heading: Node = {
			let text1 = Node.text("Hello World")
			return Node.heading(level: .h1, nodes: [text1])
		}()

		let paragraph1: Node = {
			let text1 = Node.text("Testing <>\"")
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

		let blockQuote: Node = {
			let text1 = Node.text("Test Blockquote")
			let paragraph1 = Node.paragraph(nodes: [text1])
			return .blockQuote(nodes: [paragraph1])
		}()

		let paragraph3: Node = {
			let image1 = Node.image(source: "/url", title: "title", alternate: "foo")
			let image2 = Node.image(source: "/url", title: nil, alternate: "")
			return .paragraph(nodes: [image1, .softBreak, image2])
		}()

		let list1: Node = {
			let item1 = Node.listItem(nodes: [.text("Unordered")])
			let item2 = Node.listItem(nodes: [.text("List")])
			return Node.list(isOrdered: false, nodes: [item1, item2])
		}()

		let list2: Node = {
			let item1 = Node.listItem(nodes: [.text("Ordered")])
			let item2 = Node.listItem(nodes: [.text("List")])
			return Node.list(isOrdered: true, nodes: [item1, item2])
		}()

		let paragraph4: Node = {
			let link1 = Node.link(url: "/uri", title: "title", nodes: [.text("link")])
			let link2 = Node.link(url: "/uri", title: nil, nodes: [])
			return Node.paragraph(nodes: [link1, .softBreak, link2])
		}()

		let html1 = Node.htmlBlock("""
			<table>
			<tr>
			<td>hi</td>
			</tr>
			</table>
			""")

		let paragraph5 = Node.paragraph(nodes: [.htmlInline("<a>"), .htmlInline("<bab>"), .htmlInline("<c2c>")])

		return .document(nodes: [heading, paragraph1, .thematicBreak, paragraph2,
								 code1, code2, blockQuote, paragraph3, list1, list2, paragraph4, html1, paragraph5])
	}()

	// MARK: - Tests

    func testNodeHTMLRendering() {

		let actual = nodeTree.html
		let expected = expectedHTML

		XCTAssertEqual(actual, expected)

		guard actual != expected else { return }
		print("\n********\n\n" +
			"Failed:" +
			"\nExpected: |\(expected)|" +
			"\nActual: |\(actual)|" +
			"\n********\n\n")
    }
}
