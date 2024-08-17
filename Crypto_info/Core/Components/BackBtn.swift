//
//  BackBtn.swift
//  Crypto_info
//
//  Created by gikwegbu on 11/08/2024.
//

import SwiftUI

struct BackBtn: View {
	@Environment(\.dismiss) private var dismiss
    var body: some View {
			Button {
				dismiss()
			} label: {
				Image(systemName: "xmark")
					.font(.headline)
			}
    }
}

#Preview {
    BackBtn()
}
