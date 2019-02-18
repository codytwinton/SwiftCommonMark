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
  case codeInline(String)
  case codeBlock(info: String?, _ code: String)
  case heading(_ level: HeadingLevel, _ nodes: [CommonMarkAST])
  case htmlBlock(_ rawHTML: String)
  case htmlInline(_ rawHTML: String)
  case lineBreak
  case paragraph(_ nodes: [CommonMarkAST])
  case softBreak
  case text(String)
  case thematicBreak

  // MARK: Node Type
  var type: NodeType {
    switch self {
    case .blockQuote:
      return .blockQuote
    case .codeInline:
      return .codeInline
    case .codeBlock:
      return .codeBlock
    case .heading:
      return .heading
    case .lineBreak:
      return .lineBreak
    case .htmlBlock:
      return .htmlBlock
    case .htmlInline:
      return .htmlInline
    case .paragraph:
      return .paragraph
    case .softBreak:
      return .softBreak
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
