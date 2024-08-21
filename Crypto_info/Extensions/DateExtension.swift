//
//  DateExtension.swift
//  Crypto_info
//
//  Created by gikwegbu on 21/08/2024.
//

import Foundation


extension Date {
	// "2024-03-13T20:49:26.606Z
	
	init(coinGeckoString: String) {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyy-MM-dd'T'HH:mm:ss.SSSZ"
		let date = formatter.date(from: coinGeckoString) ?? Date()
		self.init(timeInterval: 0, since: date)
	}
	
	
	private var shortFormatter: DateFormatter {
		let formatter = DateFormatter()
//		formatter.dateStyle = .short
		formatter.dateStyle = .medium
		return formatter
	}
	
	func asShortDateString() -> String {
		return shortFormatter.string(from: self)
	}
}
