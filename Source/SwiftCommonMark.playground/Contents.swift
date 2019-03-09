// MARK: Imports

import Cocoa
import SwiftCommonMark

// MARK: - Code

let markdown = """
# Testing

***

Lorem ipsum dolor
sit amet.

Lorem ipsum dolor sit amet.

"""

let document = NodeType.parseDocument(markdown: markdown)

print("*** markdown:\n\(markdown)\n\n")
print("*** document.markdown:\n\(document.commonMark)\n\n")


let html = """
<h1>Testing</h1>
<hr />
<p>Lorem ipsum dolor
sit amet.</p>
<p>Lorem ipsum dolor sit amet.</p>

"""

print("*** html:\n\(html)\n\n")
print("*** document.html:\n\(document.html)\n\n")
