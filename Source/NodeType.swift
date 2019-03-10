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

public enum NodeType: String, CaseIterable {
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
    case .codeInline, .codeBlock, .emphasis, .heading, .htmlBlock, .htmlInline, .image, .lineBreak,
         .link, .list, .listItem, .paragraph, .softBreak, .strong, .text, .thematicBreak:
      return []
    }
  }

  var regex: NSRegularExpression? {
    guard let pattern = regexPattern else { return nil }
    return try? NSRegularExpression(pattern: pattern, options: .anchorsMatchLines)
  }

  var regexPattern: String? {
    switch self {
    case .codeInline:
      return "(\\`+)([^\\`]{1}[\\s\\S\\\\]*?[^\\`]*)\\1"
    case .emphasis:
      return "([*_]{1})([\\w(]+.*[\\w)]+)(\\1)"
    case .heading:
      return "^ {0,3}(#{1,6})(?:[ \t]+|$)(.*)"
    case .strong:
      return "([*_]{2})([\\w(]+.*[\\w)]+)(\\1)"
    case .thematicBreak:
      return "^(?:(?:[ ]{0,3}\\*[ \t]*){3,}|(?:[ ]{0,3}_[ \t]*){3,}|(?:[ ]{0,3}-[ \t]*){3,})[ \t]*$"
    case .blockQuote,
         .codeBlock,
         .document,
         .htmlBlock,
         .htmlInline,
         .image,
         .lineBreak,
         .link,
         .list,
         .listItem,
         .paragraph,
         .softBreak,
         .text:
      return nil
    }
  }

  var regexTemplates: [String] {
    switch self {
    case .emphasis,
         .strong:
      return ["$2"]
    case .heading:
      return ["$1", "$2"]
    case .blockQuote,
         .codeBlock,
         .codeInline,
         .document,
         .htmlBlock,
         .htmlInline,
         .image,
         .lineBreak,
         .link,
         .list,
         .listItem,
         .paragraph,
         .softBreak,
         .text,
         .thematicBreak:
      return []
    }
  }
}

// MARK: -

public enum NodeStructure: String, CaseIterable {
  case block
  case inline
}
