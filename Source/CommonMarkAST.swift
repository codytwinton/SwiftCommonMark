//
//  CommonMarkAST.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 2/17/19.
//  Copyright © 2019 Cody Winton. All rights reserved.
//

import Foundation

// MARK: Enums

internal enum CommonMarkAST: Equatable {
  case blockQuote(_ nodes: [CommonMarkAST])
  case codeBlock(info: String?, _ code: String)
  case codeInline(String)
  case document(_ nodes: [CommonMarkAST])
  case emphasis(_ nodes: [CommonMarkAST])
  case heading(_ level: HeadingLevel, _ nodes: [CommonMarkAST])
  case htmlBlock(_ rawHTML: String)
  case htmlInline(_ rawHTML: String)
  case image(source: String, title: String?, alternate: String)
  case lineBreak
  case link(_ url: String, title: String?, _ nodes: [CommonMarkAST])
  case list(type: ListType, isTight: Bool, _ nodes: [CommonMarkAST])
  case listItem(_ nodes: [CommonMarkAST])
  case paragraph(_ nodes: [CommonMarkAST])
  case softBreak
  case strong(_ nodes: [CommonMarkAST])
  case text(String)
  case thematicBreak

  // MARK: Node Type
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

internal enum HeadingLevel: Int, CaseIterable {
  case h1 = 1, h2, h3, h4, h5, h6
}

internal enum ListType: Equatable {
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

internal enum NodeStructure: String, CaseIterable {
  case block
  case inline
}

internal enum NodeType: String, CaseIterable {
  case blockQuote
  case codeBlock
  case codeInline
  case document
  case emphasis
  case heading
  case htmlBlock
  case htmlInline
  case image
  case lineBreak
  case link
  case list
  case listItem
  case paragraph
  case softBreak
  case strong
  case text
  case thematicBreak

  var structure: NodeStructure {
    switch self {
    case .codeInline, .emphasis, .htmlInline, .image, .lineBreak, .link, .softBreak, .strong, .text:
      return .inline
    case .blockQuote, .codeBlock, .document, .heading, .htmlBlock, .list, .listItem, .paragraph, .thematicBreak:
      return .block
    }
  }

  var childBlocks: [NodeType] {
    switch self {
    case .document, .blockQuote:
      return [.blockQuote, .codeBlock, .heading, .thematicBreak, .list, .htmlBlock, .paragraph]
    case .codeInline, .codeBlock, .htmlBlock, .htmlInline, .image, .lineBreak, .softBreak, .text, .thematicBreak:
      return []
    case .emphasis, .heading, .link, .list, .listItem, .paragraph, .strong:
      return []
    }
  }

  var regex: String {
    switch self {
    case .blockQuote:
      return ""
    case .codeBlock:
      return ""
    case .codeInline:
      return "(\\`+)([^\\`]{1}[\\s\\S\\\\]*?[^\\`]*)\\1"
    case .document:
      return ""
    case .emphasis:
      return "([*_]{1})([\\w(]+.*[\\w)]+)(\\1)"
    case .heading:
      return "^ {0,3}(#{1,6})(?:[ \t]+|$)(.*)"
    case .htmlBlock:
      return ""
    case .htmlInline:
      return ""
    case .image:
      return ""
    case .lineBreak:
      return ""
    case .link:
      return ""
    case .list:
      return ""
    case .listItem:
      return ""
    case .paragraph:
      return ""
    case .softBreak:
      return ""
    case .strong:
      return "([*_]{2})([\\w(]+.*[\\w)]+)(\\1)"
    case .text:
      return ""
    case .thematicBreak:
      return "^(?:(?:[ ]{0,3}\\*[ \t]*){3,}|(?:[ ]{0,3}_[ \t]*){3,}|(?:[ ]{0,3}-[ \t]*){3,})[ \t]*$"
    }
  }

  var regexTemplates: [String] {
    switch self {
    case .blockQuote:
      return []
    case .codeBlock:
      return []
    case .codeInline:
      return []
    case .document:
      return []
    case .emphasis,
         .strong:
      return ["$2"]
    case .heading:
      return ["$1", "$2"]
    case .htmlBlock:
      return []
    case .htmlInline:
      return []
    case .image:
      return []
    case .lineBreak:
      return []
    case .link:
      return []
    case .list:
      return []
    case .listItem:
      return []
    case .paragraph:
      return []
    case .softBreak:
      return []
    case .text:
      return []
    case .thematicBreak:
      return []
    }
  }
}
