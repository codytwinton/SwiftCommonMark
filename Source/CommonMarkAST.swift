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
  case heading(level: HeadingLevel, nodes: [CommonMarkAST])
  case lineBreak
  case softBreak
  case thematicBreak
  case text(_ text: String)

  // MARK: Node Type
  var type: NodeType {
    switch self {
    case .heading:
      return .heading
    case .lineBreak:
      return .lineBreak
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
  case code
  case codeBlock
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
    case .code, .emphasis, .htmlInline, .image, .lineBreak, .link, .softBreak, .strong, .text:
      return .inline
    case .blockQuote, .codeBlock, .document, .heading, .htmlBlock, .list, .listItem, .paragraph, .thematicBreak:
      return .block
    }
  }

  var childBlocks: [NodeType] {
    switch self {
    case .document, .blockQuote:
      return [.blockQuote, .codeBlock, .heading, .thematicBreak, .list, .htmlBlock, .paragraph]
    case .code, .codeBlock, .htmlBlock, .htmlInline, .image, .lineBreak, .softBreak, .text, .thematicBreak:
      return []
    case .emphasis, .heading, .link, .list, .listItem, .paragraph, .strong:
      return []
    }
  }
}
