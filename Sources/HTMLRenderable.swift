//
//  HTMLRenderable.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/8/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: - Extensions

// MARK: - HTML Output Extensions

extension Node: HTMLRenderable {

	var html: String {
		switch self {
		case .blockQuote, .code, .codeBlock, .document, .emphasis, .heading, .htmlBlock, .htmlInline, .image,
			 .lineBreak, .link, .list, .listItem, .paragraph, .softBreak, .strong, .text, .thematicBreak:
			return ""
		}
	}
}

extension Array where Element: HTMLRenderable {

	var html: String {
		return map { $0.html }.joined()
	}
}

extension Array where Element == HTMLRenderable {

	var html: String {
		return map { $0.html }.joined()
	}
}

extension Array where Element == CommonMark {

	var html: String {
		return map { $0.html }.joined()
	}
}
