//
//  StringExt.swift
//  Crypto_info
//
//  Created by gikwegbu on 21/08/2024.
//

import Foundation


extension String {
	var removeingHTMLOccurences: String {
		return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
	}
}
