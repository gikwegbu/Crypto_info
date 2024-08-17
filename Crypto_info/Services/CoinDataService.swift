//
//  CoinDataService.swift
//  Crypto_info
//
//  Created by gikwegbu on 08/08/2024.
//

import Foundation
import Combine

class APIs {
	static let baseUrl = "https://api.coingecko.com"
	
	static func coins(
		vs_currency: String,
		order: String? = nil,
		per_page: Int? = nil,
		page: Int? = nil,
		sparkline: Bool? = nil,
		price_change_percentage: String? = nil
	) -> String {
		// Check if anyOther of the values were provided, then add the item, and the values, joined with &
		let paramDict: [String : Any?] = [
			"order": order,
			"per_page": per_page,
			"page": page ,
			"sparkline": sparkline ,
			"price_change_percentage": price_change_percentage
		]
		// change to arr, loop through the array to find matches in the object, with the value, then return both key and value pair as url string...
		// While looping through the array, if the value is not nil, location it's corresponding key pair from the dict...
		// The error is that looping through a Dictionary, has no order... hence NSURLErrorDomain
		print("George these are the keys: \(paramDict.keys)")
		print("George these are the Values: \(paramDict.values)")
		var _url = baseUrl + "/coins/markets?vs_currency=\(vs_currency)"
		
		for (k, v) in paramDict {
			if  let v = v {
				_url = _url + "&\(k)=\(v)"
			}
		}
		
		
//		for v in paramDict.values {
//			if  let v = v {
//				
////				_url = _url + "&\(k)=\(v)"
//				var i = paramDict.values.firstIndex(of: v) ?? nil
//				_url = _url + "&\(find(paramDict.values, v))=\(v)"
//			}
//		}
		return _url
	}
}


class CoinDataService {
	@Published var allCoins: [CoinModel] = []
//	private var cancellables = Set<AnyCancellable>() // for tracking purposes, we won't be using this...
	var coinSub: AnyCancellable?
	
	init() {
		print("George this is the coinsURL: \(APIs.coins(vs_currency: "usd", order: "market_cap_desc", per_page: 250, page: 1, sparkline: true, price_change_percentage: "24h"))")
		getCoins()
	}
	
	func getCoins() {
		guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else { return }
		
//		guard let url = URL(string: "\(APIs.coins(vs_currency: "usd", order: "market_cap_desc", per_page: 250, page: 1, sparkline: true, price_change_percentage: "24h"))") else { return }
		
		coinSub =	NetworkManager.download(url: url)
			.decode(type: [CoinModel].self, decoder: JSONDecoder())
//			.sink{ (completion) in
//				switch completion {
//				case .finished:
//					break
//				case .failure(let err):
//					print(err.localizedDescription)
//				}
//			} receiveValue: { [weak self] (returnedCoins) in
//				if let self = self {
//					self.allCoins = returnedCoins
//					self.coinSub?.cancel()
//				}
//			}
			.sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] (returnedCoins) in
				if let s = self {
					s.allCoins = returnedCoins
					s.coinSub?.cancel()
				}
			})
	}
}

//const url = 'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h';
