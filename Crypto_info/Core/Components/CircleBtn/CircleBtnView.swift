//
//  CircleBtnView.swift
//  Crypto_info
//
//  Created by gikwegbu on 07/08/2024.
//

import SwiftUI

struct CircleBtnView: View {
	let icon: String
	
    var body: some View {
			Image(systemName: icon)
				.font(.headline)
				.foregroundStyle(Color.theme.accent)
				.frame(width: 50, height: 50)
				.background(
					Circle()
						.foregroundStyle(Color.theme.background)
				)
				.shadow(
					color: Color.theme.accent.opacity(0.25),
					radius: 10
				)
				.padding()
    }
}

#Preview(traits: .sizeThatFitsLayout) {
	CircleBtnView(icon: "info")
			.preferredColorScheme(.light)
}
#Preview(traits: .sizeThatFitsLayout) {
	
	CircleBtnView(icon: "plus")
			.preferredColorScheme(.dark)
}
