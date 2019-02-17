//
//  CommonMark.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/8/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: Protocols

protocol CommonMarkRenderable {
    var commonMark: String { get }
}

protocol HTMLRenderable {
    var html: String { get }
}

protocol CommonMarkNode: CommonMarkRenderable, HTMLRenderable {
    var type: NodeType { get }
    var structure: NodeStructure { get }
}

protocol CommonMarkBlockNode: CommonMarkNode {
    init?(blockLine line: String)
}

// MARK: Extensions

extension CommonMarkNode {
    var structure: NodeStructure { return type.structure }
}

extension Array where Element == CommonMarkNode {
    var html: String { return map { $0.html }.joined() }
    var commonMark: String { return map { $0.commonMark }.joined() }
}

// MARK: -

enum NodeType: String, CaseIterable {
    case blockQuote, code, codeBlock, document, emphasis, heading, htmlBlock, htmlInline, image
    case lineBreak, link, list, listItem, paragraph, softBreak, strong, text, thematicBreak

    var structure: NodeStructure {
        switch self {
        case .code, .emphasis, .htmlInline, .image, .lineBreak, .link, .softBreak, .strong, .text:
            return .inline

        case .blockQuote, .codeBlock, .document, .heading, .htmlBlock, .list, .listItem, .paragraph, .thematicBreak:
            return .block
        }
    }

    var childBlocks: [NodeType] {
        switch self {
        case .document, .blockQuote:
            return [.blockQuote, .codeBlock, .heading, .thematicBreak, .list, .htmlBlock, .paragraph]

        case .code, .codeBlock, .htmlBlock, .htmlInline, .image, .lineBreak, .softBreak, .text, .thematicBreak:
            return []

        case .emphasis, .heading, .link, .list, .listItem, .paragraph, .strong:
            return []
        }
    }
}

// MARK: -

enum NodeStructure: String, CaseIterable {
    case block, inline
}
