//
//  CommonMarkAST.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 2/17/19.
//  Copyright © 2019 Cody Winton. All rights reserved.
//

import Foundation

// MARK: Enums

internal enum HeadingLevel: Int, CaseIterable {
  case h1 = 1, h2, h3, h4, h5, h6
}

internal enum CommonMarkAST: Equatable {
  case heading(level: HeadingLevel, nodes: [CommonMarkAST])
  case lineBreak, softBreak, thematicBreak
  case text(_ text: String)

  // MARK: Node Type
  var type: NodeType {
    switch self {
    case .heading: return .heading
    case .lineBreak: return .lineBreak
    case .softBreak: return .softBreak
    case .text: return .text
    case .thematicBreak: return .thematicBreak
    }
  }
}
