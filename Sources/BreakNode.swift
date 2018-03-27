//
//  BreakNode.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/23/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: -

enum BreakNode: CommonMarkBlockNode {
	case lineBreak, softBreak, thematicBreak

	var type: NodeType {
		switch self {
		case .lineBreak: return .lineBreak
		case .softBreak: return .softBreak
		case .thematicBreak: return .thematicBreak
		}
	}

	// MARK: - HTMLRenderable

	var html: String {
		switch self {
		case .lineBreak: return "<br />\n"
		case .softBreak: return "\n"
		case .thematicBreak: return "<hr />\n"
		}
	}

	// MARK: - CommonMarkRenderable

	var commonMark: String {
		switch self {
		case .lineBreak: return "\\\n"
		case .softBreak: return "\n"
		case .thematicBreak: return "***\n\n"
		}
	}

	// MARK: - Inits

	init?(blockLine line: String) {
		guard !line.isEmpty else { return nil }

		let pattern = "^(?:(?:[ ]{0,3}\\*[ \t]*){3,}|(?:[ ]{0,3}_[ \t]*){3,}|(?:[ ]{0,3}-[ \t]*){3,})[ \t]*$"
		guard let regex = try? NSRegularExpression(pattern: pattern, options: .anchorsMatchLines) else { return nil }

		let range = NSRange(location: 0, length: line.count)
		guard regex.firstMatch(in: line, options: .anchored, range: range) != nil else { return nil }
		self = .thematicBreak
	}
}
