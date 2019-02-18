//
//  HTMLRendering.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 2/17/19.
//  Copyright © 2019 Cody Winton. All rights reserved.
//

import Foundation

// MARK: Protocols

internal protocol HTMLRenderable {
  var html: String { get }
}

// MARK: Extensions

extension CommonMarkAST: HTMLRenderable {
  // MARK: HTMLRenderable
  var html: String {
    switch self {
    case let .heading(level, nodes):
      return "<\(level)>" + nodes.html + "</\(level)>\n"
    case let .text(text):
      return text
    }
  }
}

// MARK: Extensions

extension Array where Element == CommonMarkAST {
  var html: String { return map { $0.html }.joined() }
}
