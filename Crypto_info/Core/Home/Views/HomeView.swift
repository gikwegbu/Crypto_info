//
//  HomeView.swift
//  Crypto_info
//
//  Created by gikwegbu on 07/08/2024.
//

import SwiftUI

struct HomeView: View {
	@EnvironmentObject var homeVM: HomeViewModel
	@State private var showPortfolio: Bool = false // Animates right
	@State private var showPortFolioView: Bool = false // Pops up the new sheet
	
    var body: some View {
			ZStack {
				Color.theme.background
					.ignoresSafeArea()
					.sheet(isPresented: $showPortFolioView, content: {
						PortfolioView()
							.environmentObject(homeVM)
					})
				
				VStack {
					homeHeader
					HomeStatsView(showPortfolio: $showPortfolio)
					SearchBarView(searchText: $homeVM.searchText)
					columnTitles
					
					if !showPortfolio {
						coinList(
							coins: homeVM.allCoins, 
							transitionEdge: .leading
						)
					}
					
					if showPortfolio {
						coinList(
							coins: homeVM.portfolioCoins,
							transitionEdge: .trailing,
							showHoldingsColumn: true
						)
					}
					
					Spacer(minLength: 0)
				}
				
			}
    }
}


extension HomeView {
	private var homeHeader: some View {
		HStack {
			CircleBtnView(icon: showPortfolio ? "plus" : "info")
			// The ios 15.  makes the .animation to accept a 'value' of what is being animated.. so as to tie it directly, and not let it affect every other stuff around it...
				.animation(.none, value: showPortfolio)
				.onTapGesture {
					showPortFolioView.toggle()
				}
				.background(
					CircleBtnAnimationView(animate: $showPortfolio)
				)
			Spacer()
			Text(showPortfolio ? "Portfolio" : "Live Prices")
				.font(.headline)
				.fontWeight(.heavy)
				.foregroundStyle(Color.theme.accent)
				.animation(.none, value: showPortfolio)
			Spacer()
			CircleBtnView(icon: "chevron.right")
				.rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
				.onTapGesture {
					withAnimation(.spring) {
						showPortfolio.toggle()
					}
				}
		}
		.padding()
	}
	 
	
	private func  coinList(
		coins: [CoinModel],
		transitionEdge: Edge = .leading,
		showHoldingsColumn: Bool = false
	) -> some View {
		List {
			ForEach(coins) {coin in
				CoinRowView(
					coin: coin,
					showHoldingsColumn: showHoldingsColumn
				)
				.listRowInsets(
					.init(
						top: 10,
						leading: 0,
						bottom: 10,
						trailing: 10
					)
				)
			}
		}
		.listStyle(PlainListStyle())
		.transition(.move(edge: transitionEdge))
	}
	
	private var columnTitles: some View {
		HStack {
			HStack(spacing: 4) {
				Text("Coin")
				Image(systemName: "chevron.down")
//					.opacity(homeVM.matchSort(sort: .rank))
//					.opacity((homeVM.sortOption == .rank || homeVM.sortOption == .rankReversed) ? 1.0 : 0.0)
					.opacity((homeVM.matchSort(sort: .rank) || homeVM.matchSort(sort: .rankReversed)) ? 1.0 : 0.0)
					.rotationEffect(Angle(degrees: homeVM.matchSort(sort: .rank) ? 0 : 180))
			}
			.onTapGesture {
				withAnimation(.default) {
					homeVM.sortOption = homeVM.matchSort(sort: .rank) ? .rankReversed : .rank
				}
			}
			Spacer()
			if showPortfolio {
				HStack(spacing: 4) {
					Text("Holdings")
					Image(systemName: "chevron.down")
					
						.opacity((homeVM.matchSort(sort: .holdings) || homeVM.matchSort(sort: .holdingsReversed)) ? 1.0 : 0.0)
						.rotationEffect(Angle(degrees: homeVM.matchSort(sort: .holdings) ? 0 : 180))
				}
				.onTapGesture {
					withAnimation(.default) {
						homeVM.sortOption = homeVM.matchSort(sort: .holdings) ? .holdingsReversed : .holdings
					}
				}
			}
			HStack(spacing: 4) {
				Text("Price")
				Image(systemName: "chevron.down")
				
					.opacity((homeVM.matchSort(sort: .price) || homeVM.matchSort(sort: .priceReversed)) ? 1.0 : 0.0)
					.rotationEffect(Angle(degrees: homeVM.matchSort(sort: .price) ? 0 : 180))
			}
			// Making the price width match the rightColumn we built earlier
				.frame(width: UIScreen.main.bounds.width / 3.5)
				.onTapGesture {
					withAnimation(.default) {
						homeVM.sortOption = homeVM.matchSort(sort: .price) ? .priceReversed : .price
					}
				}
			
			// Adding a reloading item here
			Button {
				withAnimation(.linear(duration: 2)) {
					homeVM.reloadData()
				}
			} label: {
				Image(systemName: "goforward")
			}
			.rotationEffect(Angle(degrees: homeVM.isLoading ? 360 : 0), anchor: .center)

		}
		.font(.caption)
		.foregroundStyle(Color.theme.secondaryText)
		.padding(.horizontal)
	}
}


//#Preview {
//	NavigationView {
//		HomeView()
//			.toolbar(.hidden)
//	}
//	// Instead of passing the HomeViewModel and all the inits, we'd use the Preview Extension
//	.environmentObject(HomeViewModel())
//}

struct HomeView_previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			HomeView()
				.toolbar(.hidden)
				
		}
		.environmentObject(dev.homeVM)
	}
}
