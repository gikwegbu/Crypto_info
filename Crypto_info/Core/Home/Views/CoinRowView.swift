//
//  CoinRowView.swift
//  Crypto_info
//
//  Created by gikwegbu on 07/08/2024.
//

import SwiftUI

struct CoinRowView: View {
	let coin: CoinModel
	let showHoldingsColumn: Bool
	
    var body: some View {
			HStack(spacing: 0) {
				leftColumn
				Spacer()
				
				if showHoldingsColumn {
					centerColumn
				}
				rightColumn
				}
			.font(.headline)
			// At the moment, due to the Spacer(), the space between the left and right column isn't clickable, so adding a background to it forces it to be clickable.
			.background(
				Color.theme.background.opacity(0.001)
			)
    }
}


extension CoinRowView {
	private var leftColumn: some View {
		HStack(spacing: 0) {
			Text("\(coin.rank)")
				.font(.caption)
				.foregroundStyle(Color.theme.secondaryText)
				.frame(minWidth: 30)
			
			CoinImageView(coin: coin)
				.frame(width: 30, height: 30)
			
			Text(coin.symbol.uppercased())
				.font(.headline)
				.padding(.leading, 6)
				.foregroundStyle(Color.theme.accent)
			
		}
	}
	
	private var centerColumn: some View {
		VStack(alignment: .trailing){
			Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
				.bold()
			Text((coin.currentHoldings ?? 0).asNumberString())
		}
		.foregroundStyle(Color.theme.accent)
	}
	
	private var rightColumn: some View {
		VStack(alignment: .trailing) {
			Text("\(coin.currentPrice.asCurrencyWith6Decimals())")
				.bold()
				.foregroundStyle(Color.theme.accent)
			
			Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
				
				.foregroundStyle((coin.priceChangePercentage24H ?? 0) >= 0 ? Color.theme.green: Color.theme.accent)
			
		}
		// Using this as our App is only going to be displayed in portrait mode and not landscape,
		// Else we'd have used a Geometry reader...
		.frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
	
	}
}

//#Preview {
//	// Getting the coin with the help of the Preview extension we created...
//	CoinRowView(coin: dev.coin)
//}

struct CoinRowView_previews: PreviewProvider {
	static var previews: some View {
		Group {
			CoinRowView(coin: dev.coin, showHoldingsColumn: true)
				.previewLayout(.sizeThatFits)
				.preferredColorScheme(.light)
			
			CoinRowView(coin: dev.coin, showHoldingsColumn: true)
				.previewLayout(.sizeThatFits)
				.preferredColorScheme(.dark)
		}
	}
}
