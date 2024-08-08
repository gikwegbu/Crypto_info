//
//  HomeViewModel.swift
//  Crypto_info
//
//  Created by gikwegbu on 07/08/2024.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
	private let coinDataService = CoinDataService()
	@Published var allCoins: [CoinModel] = []
	@Published var portfolioCoins: [CoinModel] = []
	private var cancellables = Set<AnyCancellable>()
	
	
	init() {
		addSubscribers()
	}
	
	func addSubscribers () {
		coinDataService.$allCoins
			.sink { [weak self] (returnedCoins) in
				self?.allCoins = returnedCoins
			}
			.store(in: &cancellables)
	}
}
