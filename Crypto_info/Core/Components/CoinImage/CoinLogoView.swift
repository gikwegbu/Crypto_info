//
//  CoinLogoView.swift
//  Crypto_info
//
//  Created by gikwegbu on 11/08/2024.
//

import SwiftUI

struct CoinLogoView: View {
	let coin: CoinModel
	
    var body: some View {
			VStack(spacing: 4) {
				CoinImageView(coin: coin)
					.frame(width: 50, height: 50)
				Text(coin.symbol.uppercased())
					.font(.headline)
					.foregroundStyle(Color.theme.accent)
					.lineLimit(1)
					.minimumScaleFactor(0.5) // to avoid text over flow...
				Text(coin.name)
					.font(.caption)
					.foregroundStyle(Color.theme.secondaryText)
					.lineLimit(2)
					.minimumScaleFactor(0.5)
					.multilineTextAlignment(.center)
			}
    }
}

//#Preview {
//    CoinLogoView()
//}

struct CoinLogoView_previews: PreviewProvider {
	static var previews: some View {
		Group {
			CoinLogoView(coin: dev.coin)
				.padding()
				.previewLayout(.sizeThatFits)
				.preferredColorScheme(.light)
			
			CoinLogoView(coin: dev.coin)
				.padding()
				.previewLayout(.sizeThatFits)
				.preferredColorScheme(.dark)
		}
	}
}
