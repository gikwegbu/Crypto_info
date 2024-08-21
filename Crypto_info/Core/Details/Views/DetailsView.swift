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
	@StateObject private var vm: CoinDetailViewModel
	private var spacing: CGFloat = 30
	private let cols: [GridItem] = [
		GridItem(.flexible()),
		GridItem(.flexible())
	]
	
	init(coin: CoinModel) {
		_vm = StateObject(wrappedValue: CoinDetailViewModel(coin: coin))
	}
	
    var body: some View {
			ScrollView{
				VStack(spacing: 20) {
					Text("Hello")
						.frame(height: 150)
					
					titleDesign(text: "Overview")
					Divider()
					gridDesign(items: vm.overviewStatistics)
					titleDesign(text: "Additional Details")
					
					Divider()
					gridDesign(items: vm.additionalStatistics)
				}
				.padding()
			}
			.navigationTitle(vm.coin.name)
    }
}

extension DetailsView {
	private func titleDesign(text: String) -> some View {
		Text(text)
			.font(.title)
			.bold()
			.foregroundStyle(Color.theme.accent)
			.frame(maxWidth: .infinity, alignment: .leading)
	}
	
	private func gridDesign(items: [StatisticsModel]) -> some View {
		LazyVGrid(
			columns: cols,
			alignment: .leading,
			spacing: spacing,
			content: {
			
				ForEach(items) { stat in
						StatisticsView(stat: stat)
				}
		})
	}
}

//#Preview {
//    DetailsView()
//}

struct DetailsView_previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			DetailsView(coin: dev.coin)
		}
	}
}
