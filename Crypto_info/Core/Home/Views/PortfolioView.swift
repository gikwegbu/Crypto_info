//
//  PortfolioView.swift
//  Crypto_info
//
//  Created by gikwegbu on 11/08/2024.
//

import SwiftUI

struct PortfolioView: View {
	
	@EnvironmentObject var homeVM: HomeViewModel
	@State private var selectedCoin: CoinModel? = nil
	@State private var quantityText: String = ""
	@State private var showCheckmark: Bool = false
    var body: some View {
			NavigationStack {
				ScrollView {
					VStack(alignment: .leading, spacing: 0, content: {
						SearchBarView(searchText: $homeVM.searchText)
						coinLogoList
						
						if selectedCoin != nil {
							portfolioInputSection
						}
						
					})
				}
				
				.navigationTitle("Edit Portfolio")
				.toolbar{
					ToolbarItem(placement: .topBarLeading) {
						BackBtn()
					}
					
					ToolbarItem(placement: .topBarTrailing) {
						trailingNavBarBtn
					}
				}
				.onChange(of: homeVM.searchText) { oldValue, newValue in
					if newValue == "" {
						resetSelection()
					}
				}
			}
    }
}

extension PortfolioView {
	private var coinLogoList: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			LazyHStack(spacing: 10) {
				ForEach(homeVM.searchText.isEmpty ? homeVM.portfolioCoins : homeVM.allCoins) { coin in
					VStack {
						CoinLogoView(coin: coin)
							.frame(width: 75)
							.padding(4)
							.onTapGesture {
								withAnimation(.easeIn) {
									updateSelectedCoin(coin: coin)
								}
							}
							.background(
									RoundedRectangle(cornerRadius: 10)
										.stroke(coin.id == selectedCoin?.id ? Color.theme.green : Color.clear, lineWidth: 1)
							)
					}
				}
			}
			.padding(.vertical, 4)
			.padding(.leading)
		}
	}
	
	private func updateSelectedCoin(coin: CoinModel) {
		selectedCoin = coin
		if let portfolioCoin = homeVM.portfolioCoins.first(where: { $0.id == coin.id }),
			 let amount = portfolioCoin.currentHoldings {
			quantityText = "\(amount)"
		} else {
			quantityText =  ""
		}
	}
	
	private var portfolioInputSection: some View {
		VStack(spacing: 20) {
			HStack{
				Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
				Spacer()
				Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
			}
			
			Divider()
			HStack {
				Text("Amount in your portfolio: ")
				Spacer()
				TextField("Ex: 1.4", text: $quantityText)
					.multilineTextAlignment(.trailing)
					.keyboardType(.decimalPad)
			}
			Divider()
			HStack {
				Text("Current Value:")
				Spacer()
				Text(getCurrentValue().asCurrencyWith2Decimals())
			}
		}
		.animation(.none, value: selectedCoin?.id)
		.padding()
		.font(.headline)
	}
	
	private var trailingNavBarBtn: some View {
		HStack(spacing: 10) {
			Image(systemName: "checkmark")
				.opacity(showCheckmark ? 1.0 : 0.0)
			
			Button {
				saveBtnPressed()
			} label: {
				Text("save".uppercased())
			}
			.opacity(selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText) ? 1.0 : 0.0)

		}
		.font(.headline)
	}
	
	private func saveBtnPressed() {
		guard let coin = selectedCoin,
					let amount = Double(quantityText) else { return }
		// Save to Portfolio
		homeVM.updatePortfolio(coin: coin, amount: amount)
		// Show the checkmark
		withAnimation {
			showCheckmark = true
			resetSelection()
		}
		
		// hide keyboard
		UIApplication.shared.endEditing()
		
		// hide checkmark
		DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
			showCheckmark = false
		}
	}
	
	private func getCurrentValue() -> Double {
		if let quantity = Double(quantityText) {
			return quantity * (selectedCoin?.currentPrice ?? 0)
		}
		return 0
	}
	
	private func resetSelection() {
		selectedCoin = nil
		homeVM.searchText = ""
	}
}

//#Preview {
//    PortfolioView()
//}

struct PortfolioView_previews: PreviewProvider {
	static var previews: some View {
		PortfolioView()
			.environmentObject(dev.homeVM)
	}
}

