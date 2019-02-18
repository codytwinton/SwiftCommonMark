//
//  CommonMarkAST.swift
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

internal protocol HTMLRenderable {
  var html: String { get }
}

// MARK: Enums

internal enum HeadingLevel: Int, CaseIterable {
  case h1 = 1, h2, h3, h4, h5, h6
}

internal enum CommonMarkAST: Equatable, CommonMarkRenderable, HTMLRenderable {
  case heading(level: HeadingLevel, nodes: [CommonMarkAST])
  case text(_ text: String)

  // MARK: CommonMarkRenderable
  var commonMark: String {
    switch self {
    case let .heading(level, nodes):
      return String(repeating: "#", count: level.rawValue) + " " + nodes.commonMark + "\n\n"
    case let .text(text):
      return text.sanatizeHTML()
    }
  }

  // MARK: HTMLRenderable
  var html: String {
    switch self {
    case let .heading(level, nodes):
      return "<\(level)>" + nodes.html + "</\(level)>\n"
    case let .text(text):
      return text
    }
  }

  // MARK: Node Type
  var type: NodeType {
    switch self {
    case .heading: return .heading
    case .text: return .text
    }
  }

  // MARK: Inits
  init?(heading line: String) {
    guard !line.isEmpty else { return nil }

    let pattern = "^ {0,3}(#{1,6})(?:[ \t]+|$)(.*)"
    guard let regex = try? NSRegularExpression(pattern: pattern, options: .anchorsMatchLines) else { return nil }

    let range = NSRange(location: 0, length: line.count)
    let options: NSRegularExpression.MatchingOptions = .anchored

    guard let match = regex.firstMatch(in: line, options: options, range: range),
      match.range.location != NSNotFound else {
        return nil
    }

    let matchString = NSString(string: line).substring(with: match.range)
    var captures: [String] = []

    for template in ["$1", "$2"] {
      let text: String = regex.replacementString(for: match, in: matchString, offset: 0, template: template)
      captures.append(text)
    }

    let raw = captures[1]
    var components = raw.components(separatedBy: " #")

    if let last = components.last?.trimmingCharacters(in: .whitespaces) {
      let set = Set(last)
      if set.count == 1, set.first == "#" {
        components.removeLast()
      }
    }

    let markdown = components.joined(separator: " #")
      .replacingOccurrences(of: "\\#", with: "#")
      .trimmingCharacters(in: .whitespaces)

    self = .heading(
      level: HeadingLevel(rawValue: captures.first?.count ?? 0) ?? .h1,
      nodes: markdown.isEmpty ? [] : [.text(markdown)]
    )
  }

  init(text: String) {
    self = .text(text)
  }
}

// MARK: Extensions

extension Array where Element == CommonMarkAST {
  var html: String { return map { $0.html }.joined() }
  var commonMark: String { return map { $0.commonMark }.joined() }
}

// MARK: - Extensions

private extension String {
  func sanatizeHTML() -> String {
    return map { $0.sanatizeHTML() }.joined()
  }
}

private extension Character {
  func sanatizeHTML() -> String {
    switch self {
    case "<": return "&lt;"
    case ">": return "&gt;"
    case "\"": return "&quot;"
    default: return String(self)
    }
  }
}
