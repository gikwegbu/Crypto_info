//
//  DetailsView.swift
//  Crypto_info
//
//  Created by gikwegbu on 20/08/2024.
//

import SwiftUI


// we need a pre file to accept the binding coin data first, then when we get it, we'd now render the actual view

struct DetailsLoadingView: View {
	@Binding var coin: CoinModel?
	
	var body: some View {
		ZStack {
			if let coin = coin {
				DetailsView(coin: coin)
			}
		}
	}
}

struct DetailsView: View {
	
	let coin: CoinModel
	
    var body: some View {
			Text(coin.name)
    }
}

//#Preview {
//    DetailsView()
//}

struct DetailsView_previews: PreviewProvider {
	static var previews: some View {
		DetailsView(coin: dev.coin)
	}
}
