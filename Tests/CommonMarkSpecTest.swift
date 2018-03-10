//
//  CommonMarkSpecTest.swift
//  Examples
//
//  Created by Cody Winton on 3/4/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation
@testable import SwiftCommonMark

// MARK: - Enums

enum CommonMarkTestError: Error {
	case noJSONData
}

enum CommonMarkTestSection: String, EnumProtocol {
	case thematicBreak = "Thematic breaks"
	case emphasisAndStrongEmphasis = "Emphasis and strong emphasis"
	case textualContent = "Textual content"
	case lists = "Lists"
	case blockQuotes = "Block quotes"
	case blankLines = "Blank lines"
	case listItems = "List items"
	case entityAndNumericCharacterReferences = "Entity and numeric character references"
	case atxHeadings = "ATX headings"
	case codeSpans = "Code spans"
	case links = "Links"
	case hardLineBreaks = "Hard line breaks"
	case autoLinks = "Autolinks"
	case setextHeadings = "Setext headings"
	case htmlBlocks = "HTML blocks"
	case images = "Images"
	case fencedCodeBlocks = "Fenced code blocks"
	case precedence = "Precedence"
	case inlines = "Inlines"
	case rawHTML = "Raw HTML"
	case tabs = "Tabs"
	case softLineBreaks = "Soft line breaks"
	case indentedCodeBlocks = "Indented code blocks"
	case linkReferenceDefinitions = "Link reference definitions"
	case paragraphs = "Paragraphs"
	case backslashEscapes = "Backslash escapes"
}

// MARK: - Structs

struct CommonMarkSpecTest: Codable {
	let section: String
	let html: String
	let markdown: String
	let example: Int

	static func commonMarkTests(from path: String) throws -> [CommonMarkSpecTest] {
		do {
			guard let jsonData = try String(contentsOfFile: path, encoding: .utf8).data(using: .utf8) else {
				throw CommonMarkTestError.noJSONData
			}
			return try JSONDecoder().decode([CommonMarkSpecTest].self, from: jsonData)
		} catch {
			throw error
		}
	}
}
