//
//  DetailViewModel.swift
//  Crypto_info
//
//  Created by gikwegbu on 21/08/2024.
//

import Foundation
import Combine



class CoinDetailViewModel: ObservableObject {
	@Published var overviewStatistics: [StatisticsModel] = []
	@Published var additionalStatistics: [StatisticsModel] = []
	@Published var coinDescription: String? = nil
	@Published var websiteURL: String? = nil
	@Published var redditURL: String? = nil
	
	private let coinDetailService: CoinDetailDataService
	private var cancellables = Set<AnyCancellable>()
	@Published var coin: CoinModel
	
	init(coin: CoinModel) {
		self.coinDetailService = CoinDetailDataService(coin: coin)
		self.coin = coin
		self.addSubscribers()
	}
	
	private func addSubscribers() {
		coinDetailService.$coinDetail
			.combineLatest($coin)
		// Below is how we can return/transform to two arrays
			.map(mapCoinDetailsAndCoinModel)
			.sink { [weak self] (returnedArrays) in
				self?.overviewStatistics = returnedArrays.overview
				self?.additionalStatistics = returnedArrays.additional
			}
			.store(in: &cancellables)
		
		// to avoid too much abstractions, let's subscribe again
		coinDetailService.$coinDetail
			.sink { [weak self] (returnedCoinDetails) in
				self?.coinDescription = returnedCoinDetails?.readableDesc
				self?.websiteURL = returnedCoinDetails?.links?.homepage?.first
				self?.redditURL = returnedCoinDetails?.links?.subredditURL
			}
			.store(in: &cancellables)
	}
	
	private func mapCoinDetailsAndCoinModel(coinDetailModel: CoinDetailModel?, coinModel: CoinModel) -> (overview: [StatisticsModel], additional: [StatisticsModel]){
		// Overview Setup
		let overviewArr = createOverviewArr(coinModel: coinModel)
		
		// Additional
		let additionalArr = createAdditionalArr(coinModel: coinModel, coinDetailModel: coinDetailModel)
		
		
		return (overviewArr, additionalArr)
	}
	
	private func createOverviewArr(coinModel: CoinModel) -> [StatisticsModel] {
		let price = coinModel.currentPrice.asCurrencyWith6Decimals()
		let pricePercentChange = coinModel.priceChangePercentage24H
		let priceStat = StatisticsModel(title: "Current Price", value: price, percentageChange: pricePercentChange)
		
		
		let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
		let marketCapPercentChange = coinModel.marketCapChangePercentage24H
		let marketCapPercentStat = StatisticsModel(title: "Market Capitalization", value: marketCap, percentageChange: marketCapPercentChange)
		
		let rank =  "\(coinModel.rank)"
		let rankStat = StatisticsModel(title: "Rank", value: rank)
		
		let vol = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
		let volStat = StatisticsModel(title: "Volumne", value: vol)
		
		return [
			priceStat, marketCapPercentStat, rankStat, volStat
		]
	}
	
	private func createAdditionalArr(coinModel: CoinModel, coinDetailModel: CoinDetailModel?) -> [StatisticsModel] {
		let high = coinModel.high24H?.asCurrencyWith6Decimals() ?? "n/a"
		let highStat = StatisticsModel(title: "24h High", value: high)
		
		let low = coinModel.low24H?.asCurrencyWith6Decimals() ?? "n/a"
		let lowStat = StatisticsModel(title: "24h Low", value: low)
		
		let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
		let pricePercentChange2 = coinModel.priceChangePercentage24H
		let priceChangeStat = StatisticsModel(title: "24h Price Change", value: priceChange, percentageChange: pricePercentChange2)
		
		let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
		let marketCapPercentChange2 = coinModel.marketCapChangePercentage24H
		let marketCapChangeStat = StatisticsModel(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentChange2)
		
		let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
		let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
		let blockStat = StatisticsModel(title: "Block Time", value: blockTimeString)
		
		let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
		let hashingStat = StatisticsModel(title: "Hashing Algorithm", value: hashing)
		
		return [
			highStat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hashingStat
		]
	}
	
}
