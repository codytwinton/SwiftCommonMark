//
//  CommonMark.swift
//  SwiftCommonMark
//
//  Created by Cody Winton on 3/4/18.
//  Copyright © 2018 Cody Winton. All rights reserved.
//

import Foundation

enum CommonMarkOutput {
	case html
}

struct CommonMarkParser {

	let markdown: String

	func render(to output: CommonMarkOutput = .html) -> String {
		return markdown
	}
}
