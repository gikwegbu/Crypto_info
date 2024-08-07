//
//  CircleBtnAnimationView.swift
//  Crypto_info
//
//  Created by gikwegbu on 07/08/2024.
//

import SwiftUI

struct CircleBtnAnimationView: View {
	@Binding var animate: Bool
   
	var body: some View {
        Circle()
				.stroke(lineWidth: 5)
				.scale(animate  ? 1 : 0)
				.opacity(animate ? 0 : 1)
				.animation(animate ? Animation.easeInOut(duration: 1) : .none, value: animate)
    }
}

#Preview {
	CircleBtnAnimationView(animate: .constant(true))
		.foregroundStyle(.red)
		.frame(width: 100, height: 100)
}
