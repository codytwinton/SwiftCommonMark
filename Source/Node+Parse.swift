//
//  Node+Parse.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/9/19.
//  Copyright © 2019 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: - Parsing

public extension NodeType {
  static func parseDocument(markdown: String) -> Node {
    var nodes: [Node] = []
    return Node.document(nodes)
  }
}
