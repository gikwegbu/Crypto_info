//
//  SearchBarView.swift
//  Crypto_info
//
//  Created by gikwegbu on 08/08/2024.
//

import SwiftUI

struct SearchBarView: View {
	@Binding var searchText: String
	
    var body: some View {
			HStack {
				Image(systemName: "magnifyingglass")
					.foregroundStyle(searchText.isEmpty ? Color.theme.secondaryText: Color.theme.accent)
				
				TextField("Search by name or symbol...", text: $searchText)
					.foregroundStyle(Color.theme.accent)
				// The keyboardType, autocorrectionDiabled and textContentType is used to hide the
				// Suggestion for keyboards, as they don't understand cryto names and might suggest BS
					.keyboardType(.asciiCapable)
					.autocorrectionDisabled(true)
					.textContentType(.init(rawValue: ""))
					.overlay(
						Image(systemName: "xmark.circle.fill")
							.padding()
							.offset(x: 10)
							.foregroundStyle(Color.theme.accent)
							.opacity(searchText.isEmpty ? 0 : 1)
							.onTapGesture {
								UIApplication.shared.endEditing()
								searchText = ""
							}
						, alignment: .trailing
					)
			}
			.font(.headline)
			.padding()
			.background(
				RoundedRectangle(cornerRadius: 25)
					.fill(Color.theme.background)
					.shadow(color: Color.theme.accent.opacity(0.15), radius: 10)
				)
			.padding()
    }
}

#Preview(traits: .sizeThatFitsLayout) {
	SearchBarView(searchText: .constant(""))
		.preferredColorScheme(.light)
}

#Preview(traits: .sizeThatFitsLayout) {
		SearchBarView(searchText: .constant(""))
		.preferredColorScheme(.dark)
}
