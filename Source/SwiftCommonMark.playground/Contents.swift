import Cocoa

import SwiftCommonMark

var node = Node.text("What is up?")

print("node: \(node.commonMark)")
print("node: \(node.html)")
