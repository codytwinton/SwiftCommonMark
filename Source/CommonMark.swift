//
//  CommonMark.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/8/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: Protocols

internal protocol CommonMarkNode: CommonMarkRenderable, HTMLRenderable {
  var type: NodeType { get }
  var structure: NodeStructure { get }
}

internal protocol CommonMarkBlockNode: CommonMarkNode {
  init?(blockLine line: String)
}

// MARK: Extensions

extension CommonMarkNode {
  var structure: NodeStructure { return type.structure }
}

extension Array where Element == CommonMarkNode {
  var html: String { return map { $0.html }.joined() }
  var commonMark: String { return map { $0.commonMark }.joined() }
}
