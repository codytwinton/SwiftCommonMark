//
//  ASTParsing.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 2/18/19.
//  Copyright © 2019 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: - Heading Parsing

extension CommonMarkAST {
  init?(headingBlockLine line: String) {
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
}

// MARK: - Break Parsing

extension CommonMarkAST {
  init?(breakBlockLine line: String) {
    guard !line.isEmpty else { return nil }

    let pattern: String = "^(?:(?:[ ]{0,3}\\*[ \t]*){3,}|(?:[ ]{0,3}_[ \t]*){3,}|(?:[ ]{0,3}-[ \t]*){3,})[ \t]*$"
    guard let regex = try? NSRegularExpression(pattern: pattern, options: .anchorsMatchLines) else { return nil }

    let range = NSRange(location: 0, length: line.count)
    guard regex.firstMatch(in: line, options: .anchored, range: range) != nil else { return nil }
    self = .thematicBreak
  }
}
