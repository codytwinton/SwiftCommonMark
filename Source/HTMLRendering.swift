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
    case let .emphasis(nodes):
      return "<em>" + nodes.html + "</em>"
    case let .heading(level, nodes):
      return "<\(level)>" + nodes.html + "</\(level)>\n"
    case let .htmlBlock(rawHTML):
      return rawHTML + "\n"
    case let .htmlInline(rawHTML):
      return rawHTML
    case let .image(source, title, alternate):
      var image = "<img src=\"\(source)\" alt=\"\(alternate)\" "

      if let title = title, !title.isEmpty {
        image += "title=\"\(title)\" "
      }

      return image + "/>"
    case .lineBreak:
      return "<br />\n"
    case let .link(url, title, nodes):
      var link = "<a href=\"\(url)\""

      if let title = title, !title.isEmpty {
        link += " title=\"\(title)\""
      }

      return link + ">" + nodes.html + "</a>"
    case let .paragraph(nodes):
      return "<p>" + nodes.html + "</p>\n"
    case .softBreak:
      return "\n"
    case let .strong(nodes):
      return "<strong>" + nodes.html + "</strong>"
    case .thematicBreak:
      return "<hr />\n"
    case let .text(text):
      return text.sanatizeHTML()
    }
  }
}

// MARK: Extensions

extension Array where Element == CommonMarkAST {
  var html: String { return map { $0.html }.joined() }
}
