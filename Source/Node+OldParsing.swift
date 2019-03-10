//
//  Node+OldParsing.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 2/18/19.
//  Copyright © 2019 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: Extensions

public extension NodeType {
  static func parse(headingBlockLine line: String) -> Node? {
    guard !line.isEmpty else { return nil }

    let nodeType: NodeType = .heading
    guard let regex = nodeType.regex else { return nil }

    let range = NSRange(location: 0, length: line.count)

    guard let match = regex.firstMatch(in: line, options: .anchored, range: range),
      match.range.location != NSNotFound else {
        return nil
    }

    let matchString = NSString(string: line).substring(with: match.range)
    var captures: [String] = []

    for template in nodeType.regexTemplates {
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

    return .heading(
      HeadingLevel(rawValue: captures.first?.count ?? 0) ?? .h1,
      markdown.isEmpty ? [] : [.text(markdown)]
    )
  }
}

// MARK: - Break Parsing

extension NodeType {
  static func parse(breakBlockLine line: String) -> Node? {
    guard !line.isEmpty else { return nil }

    let type = NodeType.thematicBreak
    guard let regex = type.regex else { return nil }

    let range = NSRange(location: 0, length: line.count)
    guard regex.firstMatch(in: line, options: .anchored, range: range) != nil else { return nil }
    return .thematicBreak
  }
}
