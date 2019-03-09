//
//  Node.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 2/17/19.
//  Copyright © 2019 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: -

public enum Node: Equatable, CommonMarkRenderable, HTMLRenderable {
  case blockQuote(_ nodes: [Node])
  case codeBlock(info: String?, _ code: String)
  case codeInline(String)
  case document(_ nodes: [Node])
  case emphasis(_ nodes: [Node])
  case heading(_ level: HeadingLevel, _ nodes: [Node])
  case htmlBlock(_ rawHTML: String)
  case htmlInline(_ rawHTML: String)
  case image(source: String, title: String?, alternate: String)
  case lineBreak
  case link(_ url: String, title: String?, _ nodes: [Node])
  case list(type: ListType, isTight: Bool, _ nodes: [Node])
  case listItem(_ nodes: [Node])
  case paragraph(_ nodes: [Node])
  case softBreak
  case strong(_ nodes: [Node])
  case text(String)
  case thematicBreak

  var type: NodeType {
    switch self {
    case .blockQuote:
      return .blockQuote
    case .codeBlock:
      return .codeBlock
    case .codeInline:
      return .codeInline
    case .document:
      return .document
    case .emphasis:
      return .emphasis
    case .heading:
      return .heading
    case .htmlBlock:
      return .htmlBlock
    case .htmlInline:
      return .htmlInline
    case .image:
      return .image
    case .lineBreak:
      return .lineBreak
    case .link:
      return .link
    case .list:
      return .list
    case .listItem:
      return .listItem
    case .paragraph:
      return .paragraph
    case .softBreak:
      return .softBreak
    case .strong:
      return .strong
    case .text:
      return .text
    case .thematicBreak:
      return .thematicBreak
    }
  }
}

// MARK: -

public enum HeadingLevel: Int, CaseIterable {
  case h1 = 1, h2, h3, h4, h5, h6
}

// MARK: -

public enum ListType: Equatable {
  case dash
  case asterisk
  case plus
  case period(start: Int)
  case paren(start: Int)

  var htmlPrefix: String {
    switch self {
    case .dash, .asterisk, .plus:
      return "<ul>"
    case .period(let start), .paren(let start):
      var prefix = "<ol"

      if start != 1 {
        prefix += " start=\"\(start)\""
      }

      return prefix + ">"
    }
  }

  var htmlPostfix: String {
    switch self {
    case .dash, .asterisk, .plus:
      return "</ul>"
    case .period, .paren:
      return "</ol>"
    }
  }

  var commonMarkDelimiter: String {
    switch self {
    case .dash:
      return "-"
    case .asterisk:
      return "*"
    case .plus:
      return "+"
    case .period:
      return "."
    case .paren:
      return ")"
    }
  }
}
