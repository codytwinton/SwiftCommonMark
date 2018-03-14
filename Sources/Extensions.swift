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

public extension String {

	func match(regex: String, with templates: [String]) -> (captures: [String], fullMatch: String)? {

		guard let expression = try? NSRegularExpression(pattern: regex, options: .anchorsMatchLines) else {
			return nil
		}

		let options: NSRegularExpression.MatchingOptions = .anchored
		let range = NSRange(location: 0, length: self.count)
		let matchRange = expression.rangeOfFirstMatch(in: self, options: options, range: range)
		guard matchRange.location != NSNotFound else { return nil }

		let matchString = NSString(string: self).substring(with: matchRange)
		let matchesRange = NSRange(location: 0, length: matchString.count)

		var regexCaptures = Array(repeating: "", count: templates.count)
		var fullMatch = ""

		for match in expression.matches(in: matchString, options: options, range: matchesRange) {
			for (index, template) in templates.enumerated() {
				let text = expression.replacementString(for: match, in: matchString, offset: 0, template: template)
				guard text != "" else { continue }
				regexCaptures[index] = text
			}

			fullMatch = expression.replacementString(for: match, in: matchString, offset: 0, template: "$0")
		}

		return (regexCaptures, fullMatch)
	}
}
