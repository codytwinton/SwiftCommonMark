//The MIT License (MIT)
//
//Copyright (c) 2017 Caleb Kleveter
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

import Foundation

#if os(Linux) && !swift(>=3.1)
	typealias NSRegularExpression = RegularExpression
#endif

private var expressions: [String: NSRegularExpression] = [:]

public extension String {

	func match(regex: String, with templates: [String]) -> (captures: [String], fullMatch: String)? {

		let expression: NSRegularExpression

		switch expressions[regex] {
		case let regExp?:
			expression = regExp
		case nil:
			guard let exp = try? NSRegularExpression(pattern: regex, options: .anchorsMatchLines) else {
				return nil
			}

			expression = exp
			expressions[regex] = expression
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
