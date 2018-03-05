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
	/// Returns the description
	var description: String { get }
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

	var description: String { return "\(self)" }
}
