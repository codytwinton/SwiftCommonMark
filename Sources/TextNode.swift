//
//  TextNode.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/23/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: -

struct TextNode: CommonMarkNode {
    // MARK: Constants

    let type: NodeType = .text

    // MARK: Variables

    private(set) var text: String

    // MARK: - HTMLRenderable

    var html: String {
        return text.sanatizeHTML()
    }

    // MARK: - CommonMarkRenderable

    var commonMark: String {
        return text
    }

    // MARK: - Inits

    init(_ text: String) {
        self.text = text
    }
}

// MARK: - Extensions

private extension String {
    func sanatizeHTML() -> String {
        return map { $0.sanatizeHTML() }.joined()
    }
}

private extension Character {
    func sanatizeHTML() -> String {
        switch self {
        case "<": return "&lt;"
        case ">": return "&gt;"
        case "\"": return "&quot;"
        default: return String(self)
        }
    }
}
