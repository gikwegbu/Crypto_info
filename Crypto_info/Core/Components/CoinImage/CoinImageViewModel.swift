//
//  CoinImageViewModel.swift
//  Crypto_info
//
//  Created by gikwegbu on 08/08/2024.
//

import Foundation
import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject {
	@Published var image: UIImage? = nil
	@Published var isLoading: Bool = false
	private var cancellables = Set<AnyCancellable>()
	private let coin: CoinModel
	private let dataService: CoinImageService
	
	init(coin: CoinModel) {
		self.coin = coin
		self.dataService  = CoinImageService(coin: coin)
		addSubscribers()
	}
	
	private func addSubscribers() {
		dataService.$image
		// Subscribing to the published $image...
			.sink { [weak self] (_) in
				self?.isLoading = false
			} receiveValue: { [weak self] (returnedImage) in
				if let s = self {
					s.image = returnedImage
				}
			}
			.store(in: &cancellables)

	}
}
