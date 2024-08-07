//
//  Double.swift
//  Crypto_info
//
//  Created by gikwegbu on 07/08/2024.
//

import Foundation


extension Double {
	
	/// Converts a Double into a Currency with 6 decimal places
	/// ```
	/// Convert 1234.56 to $1,234.56
	/// Convert 12.3456 to $12,3456
	/// Convert 0.123456 to $0.123456
	/// ```
	private var currencyFormatter6: NumberFormatter {
		let formatter = NumberFormatter()
		formatter.usesGroupingSeparator = true
		formatter.numberStyle = .currency
		// Commenting out the locale, currency code and symbol, will default to the current device location
		// Since i'm currently based in Nigeria, Naira becomes the default value.. avoid that, as the actual
		// price is in USD $
//		formatter.locale = .current
		formatter.currencyCode = "usd"
		formatter.currencySymbol = "$"
		formatter.minimumFractionDigits = 2
		formatter.maximumFractionDigits = 6
		return formatter
	}
	
	/// This is a public function we'd call in other to access the private currencyFormatter6,
	/// it converts a Double into a Currency as a String with 6 decimal places
	/// ```
	/// Meaning 10.asCurrencyWith6Decimals(), $10.00 is returned
	/// Meaning (10.59).asCurrencyWith6Decimals(), $10.59 is returned
	/// ```
	func asCurrencyWith6Decimals() -> String {
		let numb = NSNumber(value: self)
		// as the numb can be optional, hence using ?? 0.00
		return currencyFormatter6.string(from: numb) ?? "$0.00"
	}
	
	///
	///
	private var currencyFormatter2: NumberFormatter {
		let formatter = NumberFormatter()
		formatter.usesGroupingSeparator = true
		formatter.numberStyle = .currency
		// Commenting out the locale, currency code and symbol, will default to the current device location
		// Since i'm currently based in Nigeria, Naira becomes the default value.. avoid that, as the actual
		// price is in USD $
//		formatter.locale = .current
		formatter.currencyCode = "usd"
		formatter.currencySymbol = "$"
		formatter.minimumFractionDigits = 2
		formatter.maximumFractionDigits = 2
		return formatter
	}
	
	/// This is a public function we'd call in other to access the private currencyFormatter6,
	/// it converts a Double into a Currency as a String with 2 decimal places
	/// ```
	/// Meaning 10.asCurrencyWith2Decimals(), $10.00 is returned
	/// Meaning (10.59).asCurrencyWith2Decimals(), $10.59 is returned
	/// ```
	func asCurrencyWith2Decimals() -> String {
		let numb = NSNumber(value: self)
		// as the numb can be optional, hence using ?? 0.00
		return currencyFormatter2.string(from: numb) ?? "$0.00"
	}
	///
	///
	
	/// Converst a Double into String representation
	/// ```
	/// Convert 1.2345 to "1.23"
	/// ```
	func asNumberString() -> String {
		return String(format: "%.2f", self)
	}
	
	/// Converst a Double into string representation with  percentage symbol
	/// ```
	/// Convert 1.2345 to "1.23" then finally to "1.23%"
	/// ```
	func asPercentString() -> String {
		return asNumberString() + "% "
	}
}
