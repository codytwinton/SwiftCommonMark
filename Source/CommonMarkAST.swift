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
  case text(_ text: String)

  // MARK: Node Type
  var type: NodeType {
    switch self {
    case .heading: return .heading
    case .text: return .text
    }
  }
}
