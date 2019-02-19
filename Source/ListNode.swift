//
//  ListNode.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/23/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: -

internal struct ListNode: CommonMarkNode {
  // MARK: Constants

  let type: NodeType = .list

  // MARK: Variables

  private(set) var listType: ListType
  private(set) var isTight: Bool
  private(set) var nodes: [CommonMarkNode]

  // MARK: - HTMLRenderable

  var html: String {
    var list = listType.htmlPrefix + "\n"

    switch isTight {
    case true:
      list += nodes.html
        .replacingOccurrences(of: "<li><p>", with: "<li>")
        .replacingOccurrences(of: "</p>\n</li>", with: "</li>")
    case false:
      list += nodes.html
        .replacingOccurrences(of: "<li><p>", with: "<li>\n<p>")
    }

    return list + listType.htmlPostfix + "\n"
  }

  // MARK: - CommonMarkRenderable

  var commonMark: String {
    let delimiter = listType.commonMarkDelimiter + " "
    var items = nodes.map { $0.commonMark.trimmingCharacters(in: .newlines) }

    switch listType {
    case .dash, .asterisk, .plus:
      items = items.map { delimiter + $0 }

    case .period(let start), .paren(let start):
      items = items.enumerated().map { "\(start + $0.offset)" + delimiter + $0.element }
    }

    return items.map { $0 + (isTight ? "\n" : "\n\n") }.joined() + (isTight ? "\n" : "")
  }

  // MARK: - Inits

  init(listType: ListType, isTight: Bool = true, nodes: [CommonMarkNode]) {
    // swiftlint:disable:previous function_default_parameter_at_end
    self.listType = listType
    self.isTight = isTight
    self.nodes = nodes
  }
}
