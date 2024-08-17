//
//  HomeStatsView.swift
//  Crypto_info
//
//  Created by gikwegbu on 10/08/2024.
//

import SwiftUI

struct HomeStatsView: View {
	@EnvironmentObject private var homeVM: HomeViewModel
	@Binding var showPortfolio: Bool
	
	
    var body: some View {
			HStack {
				ForEach(homeVM.statistics) { stat in
						StatisticsView(stat: stat)
						.frame(width: UIScreen.main.bounds.width / 3)
				}
			}
			// This alignment, helps place the items in the hstack, either at the ending or beginning part...
			.frame(width: UIScreen.main.bounds.width, alignment: showPortfolio ? .trailing : .leading)
    }
}

//#Preview {
//	HomeStatsView(showPortfolio: .constant(false))
//		.environmentObject(HomeViewModel())
//}

struct HomeStatsView_previews: PreviewProvider {
	static var previews: some View {
		HomeStatsView(showPortfolio: .constant(false))
			.environmentObject(dev.homeVM)

	}
}
