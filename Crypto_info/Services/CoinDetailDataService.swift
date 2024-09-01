//
//  CoinDetailDataService.swift
//  Crypto_info
//
//  Created by gikwegbu on 21/08/2024.
//

import Foundation
import Combine


class CoinDetailDataService {
	@Published var coinDetail: CoinDetailModel? = nil
	var coinDetailDataSub: AnyCancellable?
	let coin: CoinModel
	
	init(coin: CoinModel) {
		self.coin = coin
		getCoinDetails()
	}
	
	func getCoinDetails() {
		guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else { return }
		
		
			coinDetailDataSub =	NetworkManager.download(url: url)
			.decode(type: CoinDetailModel.self, decoder: JSONDecoder())
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] (returnedCoinDetail) in
				if let s = self {
					s.coinDetail = returnedCoinDetail
					s.coinDetailDataSub?.cancel()
				}
			})
	}
}

