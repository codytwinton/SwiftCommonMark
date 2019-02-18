//
//  CodeNode.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/23/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: -

internal enum CodeNode: CommonMarkNode {
  case inlineCode(String)
  case blockCode(info: String?, code: String)

  var type: NodeType {
    switch self {
    case .inlineCode:
      return .codeInline
    case .blockCode:
      return .codeBlock
    }
  }

  private var regexPattern: String {
    return "(\\`+)([^\\`]{1}[\\s\\S\\\\]*?[^\\`]*)\\1"
  }

  // MARK: - HTMLRenderable

  var html: String {
    switch self {
    case let .inlineCode(code):
      return "<code>" + code + "</code>"
    case let .blockCode(info, code):
      switch info {
      case let info?:
        return "<pre><code class=\"language-\(info)\">\(code)</code></pre>\n"
      case nil:
        return "<pre><code>\(code)</code></pre>\n"
      }
    }
  }

  // MARK: - CommonMarkRenderable

  var commonMark: String {
    switch self {
    case let .inlineCode(code):
      return "`" + code.trimmingCharacters(in: .whitespacesAndNewlines) + "`"
    case let .blockCode(info, code):
      let info = info ?? ""
      return "```\(info)\n" + code + "```\n\n"
    }
  }
}
