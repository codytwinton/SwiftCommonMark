//
//  Enum+Extensions.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/5/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

import Foundation

#if swift(>=4.2)
#else
// MARK: -

public protocol CaseIterable {
  associatedtype AllCases: Collection where AllCases.Element == Self
  /// All Cases
  static var allCases: AllCases { get }
}

// MARK: -

public extension CaseIterable where Self: Hashable {
  static var allCases: [Self] {
    return [Self](AnySequence { () -> AnyIterator<Self> in
      var raw = 0
      return AnyIterator {
        let current = withUnsafeBytes(of: &raw) { $0.load(as: Self.self) }
        guard current.hashValue == raw else {
          return nil
        }
        raw += 1
        return current
      }
    })
  }
}
#endif
