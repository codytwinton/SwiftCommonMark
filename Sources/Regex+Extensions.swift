//
//  Regex+Extensions.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/14/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

// MARK: Imports

import Foundation

// MARK: -

/*
public extension NSRegularExpression {

	func match(in str: String, templates: [String]) -> (captures: [String], fullMatch: String)? {

		let options: NSRegularExpression.MatchingOptions = .anchored

		guard let firstMatch = self.firstMatch(in: str, options: options, range: NSRange(location: 0, length: str.count)),
			firstMatch.range.location != NSNotFound else {
				return nil
		}

		let matchString = NSString(string: str).substring(with: firstMatch.range)
		let fullMatch: String = replacementString(for: firstMatch, in: matchString, offset: 0, template: "$0")

		var regexCaptures = Array(repeating: "", count: templates.count)

		for match in matches(in: matchString, options: options, range: NSRange(location: 0, length: matchString.count)) {
			for (index, template) in templates.enumerated() {
				let text: String = replacementString(for: match, in: matchString, offset: 0, template: template)
				guard text != "" else { continue }
				regexCaptures[index] = text
			}
		}

		return (regexCaptures, fullMatch)
	}
}
*/
