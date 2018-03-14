//
//  Extensions.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/5/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

import Foundation

public protocol EnumProtocol: Hashable {
	/// Returns All Enum Values
	static var all: [Self] { get }
}

public extension EnumProtocol {

	static var all: [Self] {
		typealias Type = Self
		let cases = AnySequence { () -> AnyIterator<Type> in
			var raw = 0
			return AnyIterator {
				let current: Self = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: Type.self, capacity: 1) { $0.pointee } }
				guard current.hashValue == raw else { return nil }
				raw += 1
				return current
			}
		}

		return Array(cases)
	}
}

public extension NSRegularExpression {

	func match(in str: String,
	    	      templates: [String],
	    	      options: NSRegularExpression.MatchingOptions = .anchored) -> (captures: [String], fullMatch: String)? {

		let range = NSRange(location: 0, length: str.count)
		let matchRange = self.rangeOfFirstMatch(in: str, options: options, range: range)
		guard matchRange.location != NSNotFound else { return nil }

		let matchString = NSString(string: str).substring(with: matchRange)
		let matchesRange = NSRange(location: 0, length: matchString.count)

		var regexCaptures = Array(repeating: "", count: templates.count)
		var fullMatch = ""

		for match in self.matches(in: matchString, options: options, range: matchesRange) {
			for (index, template) in templates.enumerated() {
				let text = self.replacementString(for: match, in: matchString, offset: 0, template: template)
				guard text != "" else { continue }
				regexCaptures[index] = text
			}

			fullMatch = self.replacementString(for: match, in: matchString, offset: 0, template: "$0")
		}

		return (regexCaptures, fullMatch)
	}
}
