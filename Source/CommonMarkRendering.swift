//
//  CommonMarkRendering.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 2/17/19.
//  Copyright © 2019 Cody Winton. All rights reserved.
//

import Foundation

// MARK: Protocols

internal protocol CommonMarkRenderable {
  var commonMark: String { get }
}

// MARK: Extensions

extension CommonMarkAST: CommonMarkRenderable {
  // MARK: CommonMarkRenderable
  var commonMark: String {
    switch self {
    case let .heading(level, nodes):
      return String(repeating: "#", count: level.rawValue) + " " + nodes.commonMark + "\n\n"
    case let .text(text):
      return text.sanatizeHTML()
    }
  }
}

internal extension String {
  func sanatizeHTML() -> String {
    return map { $0.sanatizeHTML() }.joined()
  }
}

internal extension Character {
  func sanatizeHTML() -> String {
    switch self {
    case "<": return "&lt;"
    case ">": return "&gt;"
    case "\"": return "&quot;"
    default: return String(self)
    }
  }
}

extension Array where Element == CommonMarkAST {
  var commonMark: String { return map { $0.commonMark }.joined() }
}
