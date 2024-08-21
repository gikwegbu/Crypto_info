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
	@State private var showFullDesc: Bool = false
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
				VStack {
					ChartView(coin: vm.coin)
						.padding(.vertical)
					VStack(spacing: 20) {
						titleDesign(text: "Overview")
						Divider()
						descriptionSection
						gridDesign(items: vm.overviewStatistics)
						titleDesign(text: "Additional Details")
						Divider()
						gridDesign(items: vm.additionalStatistics)
						websiteSection
					}
					.padding()
				}
			}
			.navigationTitle(vm.coin.name)
			.toolbar{
				ToolbarItem(placement: .topBarTrailing) {
					navBarTrailingItem
				}
			}
    }
}

extension DetailsView {
	
	private var navBarTrailingItem: some View {
		HStack {
			Text(vm.coin.symbol.uppercased())
				.font(.headline)
			.foregroundStyle(Color.theme.secondaryText)
			CoinImageView(coin: vm.coin)
				.frame(width: 25, height: 50)
		}
	}
	
	
	private var descriptionSection: some View {
		ZStack {
			if let coinDesc = vm.coinDescription,
				 !coinDesc.isEmpty {
				VStack(alignment: .leading) {
					Text(coinDesc)
						.lineLimit(showFullDesc ? nil : 3)
						.font(.callout)
						.foregroundStyle(Color.theme.secondaryText)
					
					Button {
						withAnimation(.linear) {
							showFullDesc.toggle()
						}
					} label: {
						Text(showFullDesc ? "Less..." : "Read more...")
							.font(.caption)
							.fontWeight(.bold)
							.padding(.vertical, 4)
					}
					.accentColor(.blue)
				}
				.frame(maxWidth: .infinity, alignment: .leading)
			}
		}
	}
	
	private var websiteSection: some View {
		VStack(alignment: .leading, spacing: 20) {
			if let websiteString = vm.websiteURL {
//								let url = URL(string: websiteString)
				let link = "[Website](\(websiteString))"
				Text(.init(link))
//								Link("Website", destination: url)
			}
			
			if let redditString = vm.redditURL {
				let link = "[Reddit](\(redditString))"
				Text(.init(link))
			}
		}
		.accentColor(.blue)
		.frame(maxWidth: .infinity, alignment: .leading)
		.font(.headline)
	}
	
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
