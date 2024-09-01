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
	private let marketDataService = MarketDataService()
	private let portfolioService = PortfolioDataService()
	@Published var allCoins: [CoinModel] = []
	@Published var portfolioCoins: [CoinModel] = []
	private var cancellables = Set<AnyCancellable>()
	@Published var searchText: String = ""
	@Published var isLoading: Bool = false
	@Published var statistics: [StatisticsModel] = []
	@Published var sortOption: SortOption = .holdings
	
	enum SortOption {
		case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
	}
	
	init() {
		addSubscribers()
	}
	
	func addSubscribers () {
		// The below function is no longer needed, since it's covered below in the combineLatest
//		coinDataService.$allCoins
//			.sink { [weak self] (returnedCoins) in
//				self?.allCoins = returnedCoins
//			}
//			.store(in: &cancellables)
		
		$searchText
//			.combineLatest(coinDataService.$allCoins)
		// In other to always receive the latest data when sorting is going on, we need to also listen to the sorted value, and hence pass it onto the map function
			.combineLatest(coinDataService.$allCoins, $sortOption)
			.debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
//			.map { (text, startingCoins) -> [CoinModel] in
//				return self.filterCoins(text: text, coins: startingCoins)
//			}
//			.map(filterCoins) // shorter version
		// using sorting, we have to pass the the sortValue to the map filter function
			.map(filterSortedCoins)
			.sink { [weak self] (returnedCoins) in
				self?.allCoins = returnedCoins
			}
			.store(in: &cancellables)
		
		// Updates portfolioCoins
		$allCoins
			.combineLatest(portfolioService.$savedEntities)
			.map(mapAllCoinsAndPortfolio)
			.sink { [weak self] (returnedCoins) in
				if let s = self {
					s.portfolioCoins = s.sortPortfolioIfNeeded(coins: returnedCoins)
				}
			}
			.store(in: &cancellables)
		
		// Updates the Market Data
		marketDataService.$marketData
			.combineLatest($portfolioCoins)
			.map(mapGlobalMarketData)
			.sink { [weak self] (statsModel) in
				self?.statistics = statsModel
				self?.isLoading = false
			}
			.store(in: &cancellables)
			
		
		
	}
	
	func reloadData() {
		isLoading = true
		coinDataService.getCoins()
		marketDataService.getCoins()
		HapticManager.notification(type: .success)
	}
	
	private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
		guard !text.isEmpty else {
			return coins
		}
		
		let lCaseText = text.lowercased()
		return coins.filter{ (coin) -> Bool in
			return coin.name.lowercased().contains(lCaseText) ||
						coin.symbol.lowercased().contains(lCaseText) ||
						coin.id.lowercased().contains(lCaseText)
		}
	}
	
	private func filterSortedCoins(text: String, coins: [CoinModel], sortBy: SortOption) -> [CoinModel] {
		
		var updatedCoins = filterCoins(text: text, coins: coins)
		sortCoins(sort: sortBy, coins: &updatedCoins)
		return updatedCoins
	}
	
//	private func sortCoins(sort: SortOption, coins: [CoinModel]) -> [CoinModel] {
	private func sortCoins(sort: SortOption, coins: inout [CoinModel]) {
		// So we are going to shorten this function by using 'inout', which means, that we need to pass a [CoinModel] and also return [CoinModel], i.e, the .sorted, returns an array of [CoinModel], hence using the inout shortens it a bit... Once we do this, there won't be need for the the 'return' keyword anymore, and then we'd call the .sort, instead of the .sorted
		switch sort {
		case .rank, .holdings:
//			return coins.sorted(by: { $0.rank < $1.rank })
			coins.sort(by: { $0.rank < $1.rank })
		case .rankReversed, .holdingsReversed:
//			return coins.sorted(by: { $0.rank > $1.rank })
			coins.sort(by: { $0.rank > $1.rank })
		case .price:
//			return coins.sorted(by: { $0.currentPrice < $1.currentPrice })
			coins.sort(by: { $0.currentPrice < $1.currentPrice })
		case .priceReversed:
//			return coins.sorted(by: { $0.currentPrice > $1.currentPrice })
			coins.sort(by: { $0.currentPrice > $1.currentPrice })
		}
	}
 
	private func sortPortfolioIfNeeded(coins: [CoinModel]) -> [CoinModel] {
		// This will only sort by h oldings or reversedHoldings if needed
		switch sortOption {
		case .holdings:
			return coins.sorted(by: {$0.currentHoldingsValue > $1.currentHoldingsValue})
		case .holdingsReversed:
			return coins.sorted(by: {$0.currentHoldingsValue < $1.currentHoldingsValue})

		default:
			return coins
		}
	}
	
	func matchSort(sort: SortOption) -> Bool {
		sortOption == sort
	}
	
	private func mapAllCoinsAndPortfolio(allCoins: [CoinModel], portfolioCoins: [PortfolioEntity] ) -> [CoinModel] {
		// We will be using compactMap to be sure that we are only going to loop through coins that are also in our porfolioCoins literally.
		
		allCoins.compactMap { (coin) -> CoinModel? in
			if let entity = portfolioCoins.first(where: { $0.coinId == coin.id	 }) {
				return coin.updateHoldings(amount: entity.amount)
			}
			// So when we use compactMap, it enables us to return nil, which means skipping that item
			// that doesn't meet our criteria
			// Also we are using the $allCoins instead of the coinDataService.$allCoins, so that we can work with the already filtered values.
			return nil
		}
	}
	
	
	func updatePortfolio(coin: CoinModel, amount: Double) {
		portfolioService.updatePortfolio(coin: coin, amount: amount)
	}
	
	private func mapGlobalMarketData(marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticsModel] {
		var stats: [StatisticsModel] = []
		guard let data = marketDataModel  else {
			return stats
		}
		
		let marketCap = StatisticsModel(
			title: "Market Cap",
			value: data.marketCap,
			percentageChange: data.marketCapChangePercentage24HUsd
		)
		
		let volume = StatisticsModel(
			title: "24h Volume",
			value: data.volume
		)
		let btcDominance = StatisticsModel(
			title: "BTC Dominance",
			value: data.btcDominance
		)
		
		let portfolioValue =
				portfolioCoins
				.map( { $0.currentHoldingsValue } )
				.reduce(0, +)
		
		let previousValue =
			portfolioCoins.map { (coin) -> Double in
				let currentValue = coin.currentHoldingsValue
				let percentChange = (coin.priceChangePercentage24H ?? 0) / 100
				let prevValue = currentValue / (1 + percentChange) // Finance calculation
				
				return prevValue
			}
			.reduce(0, +)
		
		let nonZeroPreviousValue = previousValue == 0 ? 1 : previousValue // This way, we won't get an error, leading to a NAN value
		let percentageChange = ((portfolioValue - previousValue) / nonZeroPreviousValue)
		
		let portfolio = StatisticsModel(
			title: "Portfolio Value",
			value: portfolioValue.asCurrencyWith2Decimals(),
			percentageChange: percentageChange
		)
		
		
		stats.append(contentsOf: [marketCap,volume, btcDominance, portfolio])
		
		return stats
	}
}
