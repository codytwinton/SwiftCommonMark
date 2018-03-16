//
//  CommonMarkRenderTests.swift
//  SwiftCommonMarkTests
//
//  Created by Cody Winton on 3/10/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

@testable import SwiftCommonMark
import XCTest

// MARK: -

class CommonMarkRenderTests: XCTestCase {

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
		<p>Testing Blockquote</p>
		</blockquote>
		<p><img src="/url" alt="foo" title="title" />
		<img src="/url" alt="" /></p>
		<ul>
		<li>Unordered</li>
		<li>List</li>
		</ul>
		<ul>
		<li>Second</li>
		</ul>
		<ul>
		<li>
		<p>Unordered</p>
		</li>
		<li>
		<p>Loose</p>
		</li>
		</ul>
		<ol start="2">
		<li>Ordered</li>
		<li>List</li>
		</ol>
		<ol>
		<li>
		<p>Ordered</p>
		</li>
		<li>
		<p>Loose</p>
		</li>
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

		What **is** *up*?\\
		Testing

		```
		Testing
		```

		```swift
		Testing 123
		```

		> Test Blockquote
		>
		> Testing Blockquote

		![foo](/url "title")
		![](/url)

		* Unordered
		* List

		+ Second

		- Unordered

		- Loose

		2. Ordered
		3. List

		1) Ordered

		2) Loose

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

		let code1 = Node.codeBlock(info: nil, code: "Testing\n")
		let code2 = Node.codeBlock(info: "swift", code: "Testing 123\n")

		let blockQuote: Node = {
			let text1 = Node.text("Test Blockquote")
			let text2 = Node.text("Testing Blockquote")
			return .blockQuote(nodes: [.paragraph(nodes: [text1]), .paragraph(nodes: [text2])])
		}()

		let paragraph3: Node = {
			let image1 = Node.image(source: "/url", title: "title", alternate: "foo")
			let image2 = Node.image(source: "/url", title: nil, alternate: "")
			return .paragraph(nodes: [image1, .softBreak, image2])
		}()

		let uList1: Node = {
			let item1 = Node.listItem(nodes: [.paragraph(nodes: [.text("Unordered")])])
			let item2 = Node.listItem(nodes: [.paragraph(nodes: [.text("List")])])
			return Node.list(type: .asterisk, isTight: true, nodes: [item1, item2])
		}()

		let uList2: Node = {
			let item1 = Node.listItem(nodes: [.paragraph(nodes: [.text("Second")])])
			return Node.list(type: .plus, isTight: true, nodes: [item1])
		}()

		let uList3: Node = {
			let item1 = Node.listItem(nodes: [.paragraph(nodes: [.text("Unordered")])])
			let item2 = Node.listItem(nodes: [.paragraph(nodes: [.text("Loose")])])
			return Node.list(type: .dash, isTight: false, nodes: [item1, item2])
		}()

		let oList1: Node = {
			let item1 = Node.listItem(nodes: [.paragraph(nodes: [.text("Ordered")])])
			let item2 = Node.listItem(nodes: [.paragraph(nodes: [.text("List")])])
			return Node.list(type: .period(start: 2), isTight: true, nodes: [item1, item2])
		}()

		let oList2: Node = {
			let item1 = Node.listItem(nodes: [.paragraph(nodes: [.text("Ordered")])])
			let item2 = Node.listItem(nodes: [.paragraph(nodes: [.text("Loose")])])
			return Node.list(type: .paren(start: 1), isTight: false, nodes: [item1, item2])
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
								 code1, code2, blockQuote, paragraph3, uList1, uList2, uList3, oList1, oList2, paragraph4, html1, paragraph5])
	}()

	// MARK: - Tests

	func testNodeEquality() {

		let expected = nodeTree
		let actual = nodeTree

		XCTAssertEqual(actual, expected)

		let aNodeArrays: [[Node]] = [[.text("abc")], [.thematicBreak], [.thematicBreak, .softBreak]]
		let bNodesArrays: [[Node]] = [[.text("def")], [.softBreak], [.thematicBreak]]

		for (i, aNodeArray) in aNodeArrays.enumerated() {
			XCTAssertFalse(aNodeArray == bNodesArrays[i])
			XCTAssertNotEqual(aNodeArray, bNodesArrays[i])
		}
	}

	func testNodeHTMLRendering() {

		let actual = nodeTree.html
		let expected = expectedHTML

		XCTAssertEqual(actual, expected)

		guard actual != expected else { return }
		print("\n\n\n\n\n\n\n********\n\n" +
			"Failed:" +
			"\n\nExpected: |\(expected)|" +
			"\n\nActual: |\(actual)|" +
			"\n********\n\n\n\n\n\n")
	}

	func testNodeCommonMarkRendering() {

		let actual = nodeTree.commonMark
		let expected = expectedCommonMark

		let actualLines = actual.components(separatedBy: .newlines)

		for (i, line) in expected.components(separatedBy: .newlines).enumerated() {
			guard line != actualLines[i] else { continue }

			print("\n\n\n\n\n\n\n********\n\n" +
				"line \(i + 1): |\(actualLines[i])|" +
				"\n********\n")
		}

		XCTAssertEqual(actual, expected)

		guard actual != expected else { return }
		print("\n\n\n\n\n\n\n********\n\n" +
			"Failed:" +
			"\n\nExpected: |\(expected)|" +
			"\n\nActual: |\(actual)|" +
			"\n********\n\n\n\n\n\n")
	}
}
