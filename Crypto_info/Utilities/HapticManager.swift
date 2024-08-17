//
//  HapticManager.swift
//  Crypto_info
//
//  Created by gikwegbu on 17/08/2024.
//

import Foundation
import SwiftUI

class HapticManager {
	static private let gen = UINotificationFeedbackGenerator()
	
	static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
		gen.notificationOccurred(type)
	}
}
