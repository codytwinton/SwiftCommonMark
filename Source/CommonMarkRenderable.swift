//
//  CommonMarkRenderable.swift
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
    case let .blockQuote(nodes):
      return nodes.map { "> " + $0.commonMark }.joined().replacingOccurrences(of: "\n\n> ", with: "\n>\n> ")
    case let .codeBlock(info, code):
      return "```\(info ?? "")\n" + code + "```\n\n"
    case let .codeInline(code):
      return "`" + code.trimmingCharacters(in: .whitespacesAndNewlines) + "`"
    case let .document(nodes):
      return nodes.commonMark.trimmingCharacters(in: .newlines) + "\n"
    case let .emphasis(nodes):
      return "*" + nodes.commonMark + "*"
    case let .heading(level, nodes):
      return String(repeating: "#", count: level.rawValue) + " " + nodes.commonMark + "\n\n"
    case let .htmlBlock(rawHTML):
      return rawHTML + "\n\n"
    case let .htmlInline(rawHTML):
      return rawHTML
    case let .image(source, title, alternate):
      var srcTitle = ""

      if let title = title {
        srcTitle += " \"" + title + "\""
      }

      return "![\(alternate)](\(source)\(srcTitle))"
    case .lineBreak:
      return "\\\n"
    case let .link(url, title, nodes):
      var srcTitle = ""

      if let title = title {
        srcTitle += " \"" + title + "\""
      }

      return "[\(nodes.commonMark)](\(url)\(srcTitle))"
    case let .list(type, isTight, nodes):
      let delimiter = type.commonMarkDelimiter + " "
      var items = nodes.map { $0.commonMark.trimmingCharacters(in: .newlines) }

      switch type {
      case .dash, .asterisk, .plus:
        items = items.map { delimiter + $0 }
      case .period(let start), .paren(let start):
        items = items.enumerated().map { "\(start + $0.offset)" + delimiter + $0.element }
      }

      return items.map { $0 + (isTight ? "\n" : "\n\n") }.joined() + (isTight ? "\n" : "")
    case let .listItem(nodes):
      return nodes.commonMark + "\n"
    case let .paragraph(nodes):
      return nodes.commonMark + "\n\n"
    case .softBreak:
      return "\n"
    case let .strong(nodes):
      return "**" + nodes.commonMark + "**"
    case .thematicBreak:
      return "***\n\n"
    case let .text(text):
      return text
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
    case "<":
      return "&lt;"
    case ">":
      return "&gt;"
    case "\"":
      return "&quot;"
    default:
      return String(self)
    }
  }
}

extension Array where Element == CommonMarkAST {
  var commonMark: String { return map { $0.commonMark }.joined() }
}
