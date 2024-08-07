//
//  Color_ext.swift
//  Crypto_info
//
//  Created by gikwegbu on 07/08/2024.
//

import Foundation
import SwiftUI


extension Color {
	static let theme = ColorTheme()
}

struct ColorTheme {
	let accent = Color("AccentColor")
	let background = Color("BackgroundColor")
	let green = Color("GreenColor")
	let red = Color("RedColor")
	let secondaryText = Color("SecondaryTextColor")
}
