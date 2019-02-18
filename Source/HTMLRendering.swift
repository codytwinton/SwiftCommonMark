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
    case let .blockQuote(nodes):
      return "<blockquote>\n" + nodes.html + "</blockquote>\n"
    case let .codeBlock(info, code):
      switch info {
      case let info?:
        return "<pre><code class=\"language-\(info)\">\(code)</code></pre>\n"
      case nil:
        return "<pre><code>\(code)</code></pre>\n"
      }
    case let .codeInline(code):
      return "<code>" + code + "</code>"
    case let .heading(level, nodes):
      return "<\(level)>" + nodes.html + "</\(level)>\n"
    case .htmlBlock(let rawHTML):
      return rawHTML + "\n"
    case .htmlInline(let rawHTML):
      return rawHTML
    case .lineBreak:
      return "<br />\n"
    case let .paragraph(nodes):
      return "<p>" + nodes.html + "</p>\n"
    case .softBreak:
      return "\n"
    case .thematicBreak:
      return "<hr />\n"
    case let .text(text):
      return text
    }
  }
}

// MARK: Extensions

extension Array where Element == CommonMarkAST {
  var html: String { return map { $0.html }.joined() }
}