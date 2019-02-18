//
//  HeadingNode.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/23/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: -

internal struct HeadingNode: CommonMarkBlockNode, Equatable {
  // MARK: Static Functions
  static func == (lhs: HeadingNode, rhs: HeadingNode) -> Bool {
    guard lhs.level == rhs.level else { return false }
    return lhs.html == rhs.html
  }

  // MARK: Constants

  let type: NodeType = .heading

  // MARK: Variables

  private(set) var level: HeadingLevel
  private(set) var nodes: [CommonMarkNode]

  // MARK: - HTMLRenderable

  var html: String {
    return "<\(level)>" + nodes.html + "</\(level)>\n"
  }

  // MARK: - CommonMarkRenderable

  var commonMark: String {
    return String(repeating: "#", count: level.rawValue) + " " + nodes.commonMark + "\n\n"
  }

  // MARK: - Inits

  init(level: HeadingLevel, nodes: [CommonMarkNode]) {
    self.level = level
    self.nodes = nodes
  }

  init?(blockLine line: String) {
    guard !line.isEmpty else { return nil }

    let nodeType: NodeType = .heading
    guard let regex = try? NSRegularExpression(pattern: nodeType.regex, options: .anchorsMatchLines) else { return nil }

    let range = NSRange(location: 0, length: line.count)
    let options: NSRegularExpression.MatchingOptions = .anchored

    guard let match = regex.firstMatch(in: line, options: options, range: range),
      match.range.location != NSNotFound else {
        return nil
    }

    let matchString = NSString(string: line).substring(with: match.range)
    var captures: [String] = []

    for template in nodeType.regexTemplates {
      let text: String = regex.replacementString(for: match, in: matchString, offset: 0, template: template)
      captures.append(text)
    }

    level = HeadingLevel(rawValue: captures.first?.count ?? 0) ?? .h1

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
    nodes = [TextNode(markdown)]
  }
}
