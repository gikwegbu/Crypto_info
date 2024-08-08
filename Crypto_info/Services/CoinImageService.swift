//
//  CoinImageService.swift
//  Crypto_info
//
//  Created by gikwegbu on 08/08/2024.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService {
	@Published var image: UIImage? = nil
	private var coinImageSub: AnyCancellable?
	private let coin: CoinModel
	private let fileManager = LocalFileManager.instance
	private let folderName: String = "coin_images"
	private var imageName: String
	
	init(coin: CoinModel) {
		self.coin = coin
		self.imageName = coin.id
		getCoinImage()
	}
	
	private func getCoinImage() {
		if let savedCoinImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
			image = savedCoinImage
		} else {
			downloadCoinImage()
		}
	}
	
	private func downloadCoinImage() {
		
		guard let url = URL(string: coin.image) else { return }
		
		coinImageSub =	NetworkManager.download(url: url)
			.tryMap({ (data) -> UIImage? in
				return UIImage(data: data)
			})
			.sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] (returnedImage) in
				if let s = self,
					let	 downloadedImg = returnedImage {
					s.image = downloadedImg
					s.coinImageSub?.cancel()
					s.fileManager.saveImage(image: downloadedImg, imageName: s.imageName, folderName: s.folderName)
				}
			})
	}
}
