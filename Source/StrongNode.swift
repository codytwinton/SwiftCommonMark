//
//  StrongNode.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/23/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: -

internal struct StrongNode: CommonMarkNode {
  // MARK: Constants

  let type: NodeType = .strong

  // MARK: Variables

  private(set) var nodes: [CommonMarkNode]

  private var regexPattern: String {
    return type.regex
  }

  private var regexTemplates: [String] {
    return type.regexTemplates
  }

  // MARK: - HTMLRenderable

  var html: String {
    return "<strong>" + nodes.html + "</strong>"
  }

  // MARK: - CommonMarkRenderable

  var commonMark: String {
    return "**" + nodes.commonMark + "**"
  }

  // MARK: - Inits

  init(nodes: [CommonMarkNode]) {
    self.nodes = nodes
  }
}
