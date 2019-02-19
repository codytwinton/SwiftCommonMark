//
//  NodeType.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 2/18/19.
//  Copyright © 2019 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: -

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

// MARK: -

internal enum NodeStructure: String, CaseIterable {
  case block
  case inline
}
