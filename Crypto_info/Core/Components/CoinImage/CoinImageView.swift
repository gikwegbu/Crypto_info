//
//  CoinImageView.swift
//  Crypto_info
//
//  Created by gikwegbu on 08/08/2024.
//

import SwiftUI

struct CoinImageView: View {
	@StateObject var vm: CoinImageViewModel
	
	init(coin: CoinModel) {
		_vm = StateObject(wrappedValue: CoinImageViewModel(coin: coin))
	}
	
    var body: some View {
			ZStack {
				if let image = vm.image {
					Image(uiImage: image)
						.resizable()
						.scaledToFit()
				} else if vm.isLoading {
					ProgressView()
				} else {
					Image(systemName: "questionmark")
						.foregroundStyle(Color.theme.secondaryText)
				}
			}
    }
}

//#Preview(traits: .sizeThatFitsLayout) {
//    CoinImageView(coin: <#T##CoinModel#>)
//		.padding()
//}

struct CoinImageView_previews: PreviewProvider {
	static var previews: some View {
		CoinImageView(coin: DeveloperPreview.instance.coin)
			.padding()
			.fixedSize()
	}
}
