//
//  MarketDataService.swift
//  Crypto_info
//
//  Created by gikwegbu on 11/08/2024.
//

import Foundation
import Combine



class MarketDataService {
	@Published var marketData: MarketDataModel? = nil
	var marketDataSub: AnyCancellable?
	
	init() {
		getCoins()
	}
	
	func getCoins() {
		guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
		
		
		marketDataSub =	NetworkManager.download(url: url)
			.decode(type: GlobalData.self, decoder: JSONDecoder())
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] (returnedGlobalData) in
				if let s = self {
					s.marketData = returnedGlobalData.data
					s.marketDataSub?.cancel()
				}
			})
	}
}
