//
//  HTMLNode.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/23/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: Enums

enum HTMLNode: CommonMarkNode {
    case block(String)
    case inline(String)

    var type: NodeType {
        switch self {
        case .block: return .htmlBlock
        case .inline: return .htmlInline
        }
    }

    // MARK: - HTMLRenderable

    var html: String {
        switch self {
        case .block(let content): return content + "\n"
        case .inline(let content): return content
        }
    }

    // MARK: - CommonMarkRenderable

    var commonMark: String {
        switch self {
        case .block(let content): return content + "\n\n"
        case .inline(let content): return content
        }
    }
}
