//
//  Node+Parsing.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 2/18/19.
//  Copyright © 2019 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: - Heading Parsing

extension Node {
  init?(headingBlockLine line: String) {
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
      HeadingLevel(rawValue: captures.first?.count ?? 0) ?? .h1,
      markdown.isEmpty ? [] : [.text(markdown)]
    )
  }
}

// MARK: - Break Parsing

extension Node {
  init?(breakBlockLine line: String) {
    guard !line.isEmpty else { return nil }

    let pattern: String = NodeType.thematicBreak.regex
    guard let regex = try? NSRegularExpression(pattern: pattern, options: .anchorsMatchLines) else { return nil }

    let range = NSRange(location: 0, length: line.count)
    guard regex.firstMatch(in: line, options: .anchored, range: range) != nil else { return nil }
    self = .thematicBreak
  }
}

// MARK: - Old Parsing

/*
extension NodeType {
  // MARK: Functions

  static func parse(markdown: String) -> Node {
    var blocks: [Node] = []
    var openBlocks: [NodeType] = [.document]

    for line in markdown.components(separatedBy: .newlines) {
      var foundMatch = false

      for type in blockTypes {
        guard let regex = type.blockRegex else { continue }

        let options: NSRegularExpression.MatchingOptions = .anchored
        guard let match = regex.firstMatch(in: line, options: options, range: NSRange(location: 0, length: line.count)),
          match.range.location != NSNotFound else {
            continue
        }

        let matchString = NSString(string: line).substring(with: match.range)
        var captures = Array(repeating: "", count: type.blockTemplates.count)

        for (index, template) in type.blockTemplates.enumerated() {
          let text: String = regex.replacementString(for: match, in: matchString, offset: 0, template: template)
          captures[index] = text
        }

        blocks.append(type.block(from: line, captures: captures))
        foundMatch = true
        break
      }

      guard !foundMatch else { continue }
      parseParagraph(line: line, &blocks, &openBlocks)
    }

    var document = Node.document(nodes: blocks)
    document.parseBlockInlines()
    return document
  }

  // MARK: Specific Parsing

  private static func parseParagraph(line: String, _ blocks: inout [Node], _ openBlocks: inout [NodeType]) {
    switch blocks.last {
    case .paragraph(var nodes)? where openBlocks.last == .paragraph:
      if let node = nodes.last, case .text(let text) = node, text.last != "\n" {
        blocks.removeLast()
        nodes.removeLast()

        nodes.append(.text(text + "\n" + line))
        blocks.append(.paragraph(nodes: nodes))
      } else if !line.isEmpty {
        blocks.append(.paragraph(nodes: [.text(line)]))
      }

    default:
      if !line.isEmpty {
        blocks.append(.paragraph(nodes: [.text(line)]))
        openBlocks.append(.paragraph)
      }
    }
  }
}

// MARK: -

private extension Node {
  mutating func parseBlockInlines() {
    switch self {
    case .paragraph(let nodes):
      self = .paragraph(nodes: nodes.flatMap { node -> [Node] in
        guard case .text(let text) = node else { return [] }
        return text.parseParagraphInlines()
      })

    case let .heading(level, nodes):
      self = .heading(level: level, nodes: nodes.flatMap { node -> [Node] in
        guard case .text(let text) = node else { return [] }
        return text.parseHeadingInlines()
      })

    case .document(var nodes):
      nodes.parseBlockInlines()
      self = .document(nodes: nodes)

    case .blockQuote(var nodes):
      nodes.parseBlockInlines()
      self = .blockQuote(nodes: nodes)

    case .list(let type, let isTight, var nodes):
      nodes.parseBlockInlines()
      self = .list(type: type, isTight: isTight, nodes: nodes)

    case .listItem(var nodes):
      nodes.parseBlockInlines()
      self = .listItem(nodes: nodes)
    case .code, .codeBlock, .emphasis, .image, .htmlBlock, .htmlInline,
         .lineBreak, .link, .softBreak, .strong, .text, .thematicBreak:
      break
    }
  }
}

// MARK: -

private extension Array where Element == Node {
  mutating func parseBlockInlines() {
    for index in 0..<count {
      self[index].parseBlockInlines()
    }
  }
}

// MARK: -

private extension String {
  func parseParagraphInlines() -> [Node] {
    var nodes: [Node] = []

    let lines = trimmingCharacters(in: .newlines).components(separatedBy: .newlines)

    for (index, line) in lines.enumerated() {
      guard !line.isEmpty else { continue }
      nodes.append(.text(line))
      guard index < lines.count - 1 else { continue }
      nodes.append(.softBreak)
    }

    return nodes
  }

  func parseHeadingInlines() -> [Node] {
    return [.text(self)]
  }
}
*/
