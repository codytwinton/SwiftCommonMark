//
//  DocumentTests.swift
//  SwiftCommonMarkTests
//
//  Created by Cody Winton on 3/10/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

@testable import SwiftCommonMark
import XCTest

// MARK: -

class DocumentTests: XCTestCase {

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

	let node: DocumentNode = {
		let heading: HeadingNode = {
			let text1 = TextNode("Hello World")
			return HeadingNode(level: .h1, nodes: [text1])
		}()

		let paragraph1: ParagraphNode = {
			let text1 = TextNode("Testing <>\"")
			let text2 = TextNode("Testing now: ")
			let code1 = CodeNode.inline("Testing Code")
			return ParagraphNode(nodes: [text1, BreakNode.softBreak, text2, code1])
		}()

		let paragraph2: ParagraphNode = {
			let text1 = TextNode("What ")
			let strong1 = StrongNode(nodes: [TextNode("is")])
			let text2 = TextNode(" ")
			let emphasis1 = EmphasisNode(nodes: [TextNode("up")])
			let text3 = TextNode("?")
			let text4 = TextNode("Testing")

			return ParagraphNode(nodes: [text1, strong1, text2, emphasis1, text3, BreakNode.lineBreak, text4])
		}()

		let code1 = CodeNode.block(info: nil, code: "Testing\n")
		let code2 = CodeNode.block(info: "swift", code: "Testing 123\n")

		let blockQuote: BlockQuoteNode = {
			let text1 = TextNode("Test Blockquote")
			let text2 = TextNode("Testing Blockquote")
			return BlockQuoteNode(nodes: [ParagraphNode(nodes: [text1]), ParagraphNode(nodes: [text2])])
		}()

		let paragraph3: ParagraphNode = {
			let image1 = ImageNode(source: "/url", title: "title", alternate: "foo")
			let image2 = ImageNode(source: "/url", title: nil, alternate: "")
			return ParagraphNode(nodes: [image1, BreakNode.softBreak, image2])
		}()

		let uList1: ListNode = {
			let item1 = ListItemNode(nodes: [ParagraphNode(nodes: [TextNode("Unordered")])])
			let item2 = ListItemNode(nodes: [ParagraphNode(nodes: [TextNode("List")])])
			return ListNode(listType: .asterisk, isTight: true, nodes: [item1, item2])
		}()

		let uList2: ListNode = {
			let item1 = ListItemNode(nodes: [ParagraphNode(nodes: [TextNode("Second")])])
			return ListNode(listType: .plus, isTight: true, nodes: [item1])
		}()

		let uList3: ListNode = {
			let item1 = ListItemNode(nodes: [ParagraphNode(nodes: [TextNode("Unordered")])])
			let item2 = ListItemNode(nodes: [ParagraphNode(nodes: [TextNode("Loose")])])
			return ListNode(listType: .dash, isTight: false, nodes: [item1, item2])
		}()

		let oList1: ListNode = {
			let item1 = ListItemNode(nodes: [ParagraphNode(nodes: [TextNode("Ordered")])])
			let item2 = ListItemNode(nodes: [ParagraphNode(nodes: [TextNode("List")])])
			return ListNode(listType: .period(start: 2), isTight: true, nodes: [item1, item2])
		}()

		let oList2: ListNode = {
			let item1 = ListItemNode(nodes: [ParagraphNode(nodes: [TextNode("Ordered")])])
			let item2 = ListItemNode(nodes: [ParagraphNode(nodes: [TextNode("Loose")])])
			return ListNode(listType: .paren(start: 1), isTight: false, nodes: [item1, item2])
		}()

		let paragraph4: ParagraphNode = {
			let link1 = LinkNode(url: "/uri", title: "title", nodes: [TextNode("link")])
			let link2 = LinkNode(url: "/uri", title: nil, nodes: [])
			return ParagraphNode(nodes: [link1, BreakNode.softBreak, link2])
		}()

		let html1 = HTMLNode.block("""
			<table>
			<tr>
			<td>hi</td>
			</tr>
			</table>
			""")

		let paragraph5 = ParagraphNode(nodes: [HTMLNode.inline("<a>"), HTMLNode.inline("<bab>"), HTMLNode.inline("<c2c>")])

		return DocumentNode(nodes: [heading, paragraph1, BreakNode.thematicBreak, paragraph2,
								 code1, code2, blockQuote, paragraph3, uList1, uList2, uList3, oList1, oList2, paragraph4, html1, paragraph5])
	}()

	// MARK: - Tests

	func testHTML() {
		let actual = node.html
		let expected = expectedHTML

		XCTAssertEqual(actual, expected, "\n\n\n\n\n\n\n********\n\n" +
			"Failed HTML:" +
			"\n\nExpected: |\(expected)|" +
			"\n\nActual: |\(actual)|" +
			"\n********\n\n\n\n\n\n")
	}

	func testCommonMark() {
		let actual = node.commonMark
		let expected = expectedCommonMark

		let actualLines = actual.components(separatedBy: .newlines)

		for (i, expected) in expected.components(separatedBy: .newlines).enumerated() {
			let actual: String?

			switch i < actualLines.count {
			case true: actual = actualLines[i]
			case false: actual = nil
			}

			guard expected != actual else { continue }
			print("\n\n\n\n\n\n\n********\n\n" +
				"line \(i + 1)" +
				"\n\nExpected: |\(expected)|" +
				"\n\nActual: |\(actual ?? "nil")|" +
				"\n********\n")
		}

		XCTAssertEqual(actual, expected, "\n\n\n\n\n\n\n********\n\n" +
			"Failed CommonMark:" +
			"\n\nExpected: |\(expected)|" +
			"\n\nActual: |\(actual)|" +
			"\n********\n\n\n\n\n\n")
	}
}
