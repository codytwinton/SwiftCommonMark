//
//  Node+Parse.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/9/19.
//  Copyright © 2019 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: - Parsing

public extension NodeType {
  static func parseDocument(markdown: String) -> Node {
    var blocks: [Node] = []
    var openBlocks: [NodeType] = [.document]

    for line in markdown.components(separatedBy: .newlines) {
      var foundMatch = false

      for type in NodeType.allCases.filter({ $0.structure == .block }) {
        guard let regex = type.regex,
          let match = regex.firstMatch(in: line, options: .anchored, range: NSRange(location: 0, length: line.count)),
          match.range.location != NSNotFound else {
            continue
        }

        let matchString = NSString(string: line).substring(with: match.range)
        var captures = Array(repeating: "", count: type.regexTemplates.count)

        for (index, template) in type.regexTemplates.enumerated() {
          let text: String = regex.replacementString(for: match, in: matchString, offset: 0, template: template)
          captures[index] = text
        }

        //blocks.append(type.block(from: line, captures: captures))
        foundMatch = true
        break
      }

      guard !foundMatch else { continue }
      parseParagraph(line: line, &blocks, &openBlocks)
    }

    return Node.document(blocks).parsedInlineBlocks()
  }
}

// MARK: -

extension NodeType {
  // MARK: Specific Parsing

  private static func parseParagraph(line: String, _ blocks: inout [Node], _ openBlocks: inout [NodeType]) {
    switch blocks.last {
    case .paragraph(var nodes)? where openBlocks.last == .paragraph:
      if let node = nodes.last, case .text(let text) = node, text.last != "\n" {
        blocks.removeLast()
        nodes.removeLast()

        nodes.append(.text(text + "\n" + line))
        blocks.append(.paragraph(nodes))
      } else if !line.isEmpty {
        blocks.append(.paragraph([.text(line)]))
      }

    default:
      if !line.isEmpty {
        blocks.append(.paragraph([.text(line)]))
        openBlocks.append(.paragraph)
      }
    }
  }
}

// MARK: -

private extension Node {
  func parsedInlineBlocks() -> Node {
    switch self {
    case let .listItem(nodes):
      return .listItem(nodes.parsedInlineBlocks())
    case let .document(nodes):
      return .document(nodes.parsedInlineBlocks())
    case let .blockQuote(nodes):
      return .blockQuote(nodes.parsedInlineBlocks())
    case let .list(type, isTight, nodes):
      return .list(type: type, isTight: isTight, nodes.parsedInlineBlocks())
    case let .paragraph(nodes):
      return .paragraph(nodes.flatMap { node -> [Node] in
        guard case let .text(text) = node else { return [] }
        return text.parsedInlineParagraph()
      })

    case let .heading(level, nodes):
      return .heading(level, nodes.flatMap { node -> [Node] in
        guard case .text(let text) = node else { return [] }
        return text.parsedInlineHeading()
      })
    case .codeInline, .codeBlock, .emphasis, .image, .htmlBlock, .htmlInline,
         .lineBreak, .link, .softBreak, .strong, .text, .thematicBreak:
      return self
    }
  }
}

// MARK: -

private extension Array where Element == Node {
  func parsedInlineBlocks() -> [Node] {
    return self.map { $0.parsedInlineBlocks() }
  }
}

// MARK: -

private extension String {
  func parsedInlineParagraph() -> [Node] {
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

  func parsedInlineHeading() -> [Node] {
    return [.text(self)]
  }
}
