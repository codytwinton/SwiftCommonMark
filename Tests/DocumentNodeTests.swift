//
//  DocumentNodeTests.swift
//  SwiftCommonMarkTests
//
//  Created by Cody Winton on 3/10/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

@testable import SwiftCommonMark
import XCTest

// MARK: -

internal class DocumentNodeTests: XCTestCase {
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

  let node: CommonMarkAST = {
    let heading: CommonMarkAST = {
      let text1: CommonMarkAST = .text("Hello World")
      return .heading(.h1, [text1])
    }()

    let paragraph1: CommonMarkAST = {
      let text1: CommonMarkAST = .text("Testing <>\"")
      let text2: CommonMarkAST = .text("Testing now: ")
      let code1: CommonMarkAST = .codeInline("Testing Code")
      return .paragraph([text1, .softBreak, text2, code1])
    }()

    let paragraph2: CommonMarkAST = {
      let text1: CommonMarkAST = .text("What ")
      let strong1: CommonMarkAST = .strong([.text("is")])
      let text2: CommonMarkAST = .text(" ")
      let emphasis1: CommonMarkAST = .emphasis([.text("up")])
      let text3: CommonMarkAST = .text("?")
      let text4: CommonMarkAST = .text("Testing")

      return .paragraph([text1, strong1, text2, emphasis1, text3, .lineBreak, text4])
    }()

    let code1: CommonMarkAST = .codeBlock(info: nil, "Testing\n")
    let code2: CommonMarkAST = .codeBlock(info: "swift", "Testing 123\n")

    let blockQuote: CommonMarkAST = {
      let text1: CommonMarkAST = .text("Test Blockquote")
      let text2: CommonMarkAST = .text("Testing Blockquote")
      return .blockQuote([.paragraph([text1]), .paragraph([text2])])
    }()

    let paragraph3: CommonMarkAST = {
      let image1: CommonMarkAST = .image(source: "/url", title: "title", alternate: "foo")
      let image2: CommonMarkAST = .image(source: "/url", title: nil, alternate: "")
      return .paragraph([image1, .softBreak, image2])
    }()

    let uList1: CommonMarkAST = {
      let item1: CommonMarkAST = .listItem([.paragraph([.text("Unordered")])])
      let item2: CommonMarkAST = .listItem([.paragraph([.text("List")])])
      return .list(type: .asterisk, isTight: true, [item1, item2])
    }()

    let uList2: CommonMarkAST = {
      let item1: CommonMarkAST = .listItem([.paragraph([.text("Second")])])
      return .list(type: .plus, isTight: true, [item1])
    }()

    let uList3: CommonMarkAST = {
      let item1: CommonMarkAST = .listItem([.paragraph([.text("Unordered")])])
      let item2: CommonMarkAST = .listItem([.paragraph([.text("Loose")])])
      return .list(type: .dash, isTight: false, [item1, item2])
    }()

    let oList1: CommonMarkAST = {
      let item1: CommonMarkAST = .listItem([.paragraph([.text("Ordered")])])
      let item2: CommonMarkAST = .listItem([.paragraph([.text("List")])])
      return .list(type: .period(start: 2), isTight: true, [item1, item2])
    }()

    let oList2: CommonMarkAST = {
      let item1: CommonMarkAST = .listItem([.paragraph([.text("Ordered")])])
      let item2: CommonMarkAST = .listItem([.paragraph([.text("Loose")])])
      return .list(type: .paren(start: 1), isTight: false, [item1, item2])
    }()

    let paragraph4: CommonMarkAST = {
      let link1: CommonMarkAST = .link("/uri", title: "title", [.text("link")])
      let link2: CommonMarkAST = .link("/uri", title: nil, [])
      return .paragraph([link1, .softBreak, link2])
    }()

    let html1: CommonMarkAST = .htmlBlock(
      """
      <table>
      <tr>
      <td>hi</td>
      </tr>
      </table>
      """
    )

    let paragraph5: CommonMarkAST = .paragraph([.htmlInline("<a>"), .htmlInline("<bab>"), .htmlInline("<c2c>")])

    return .document(
      [
        heading,
        paragraph1,
        .thematicBreak,
        paragraph2,
        code1,
        code2,
        blockQuote,
        paragraph3,
        uList1,
        uList2,
        uList3,
        oList1,
        oList2,
        paragraph4,
        html1,
        paragraph5
      ]
    )
  }()

  // MARK: - Tests

  func testHTML() {
    let actual = node.html
    let expected = expectedHTML

    XCTAssertEqual(
      actual,
      expected,
      "\n\n\n\n\n\n\n********\n\n" +
        "Failed HTML:" +
        "\n\nExpected: |\(expected)|" +
        "\n\nActual: |\(actual)|" +
      "\n********\n\n\n\n\n\n"
    )
  }

  func testCommonMark() {
    let actual = node.commonMark
    let expected = expectedCommonMark

    let actualLines = actual.components(separatedBy: .newlines)

    for (index, expected) in expected.components(separatedBy: .newlines).enumerated() {
      let actual: String?

      switch index < actualLines.count {
      case true:
        actual = actualLines[index]
      case false:
        actual = nil
      }

      guard expected != actual else { continue }
      print(
        "\n\n\n\n\n\n\n********\n\n" +
          "line \(index + 1)" +
          "\n\nExpected: |\(expected)|" +
          "\n\nActual: |\(actual ?? "nil")|" +
        "\n********\n"
      )
    }

    XCTAssertEqual(
      actual,
      expected,
      "\n\n\n\n\n\n\n********\n\n" +
        "Failed CommonMark:" +
        "\n\nExpected: |\(expected)|" +
        "\n\nActual: |\(actual)|" +
      "\n********\n\n\n\n\n\n"
    )
  }
}
