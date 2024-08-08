//
//  UIApplication_ext.swift
//  Crypto_info
//
//  Created by gikwegbu on 08/08/2024.
//

import Foundation
import SwiftUI

extension UIApplication {
	func endEditing() {
		sendAction(
			#selector(UIResponder.resignFirstResponder),
			to: nil,
			from: nil,
			for: nil
		)
	}
}
