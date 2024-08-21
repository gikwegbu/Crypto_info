//
//  ChartView.swift
//  Crypto_info
//
//  Created by gikwegbu on 21/08/2024.
//

import SwiftUI

struct ChartView: View {
	
	private let data: [Double]
	private let maxY: Double
	private let minY: Double
	private let lineColor: Color
	private let startingDate: Date
	private let endingDate: Date
	@State private var percentage: CGFloat = 0
	
	init(coin: CoinModel) {
		data = coin.sparklineIn7D?.price ?? []
		maxY = data.max() ?? 0
		minY = data.min() ?? 0
		
		let priceChange = (data.last ?? 0) - (data.first ?? 0)
		lineColor = priceChange > 0 ? Color.theme.green : Color.theme.red
		
		endingDate =  Date(coinGeckoString: coin.lastUpdated ?? "")
		// NB: The sparklineIn7D, is 7days -ish timeline... so using minus (-), to go back 7 days,
		// Also, number of seconds in a day = 24hrs * 60mins * 60seconds
		// Then, days * the above, gets you the number of days, in seconds.... you can then multiply by 1,000 to get the miliseconds equivalent...
		startingDate = endingDate.addingTimeInterval(-7*24*60*60)
	}

	
    var body: some View {
			VStack {
				chartView
					.frame(height: 200)
					.background(chartBg)
					.overlay(chartYAxis.padding(.horizontal, 4), alignment: .leading)
				
				chartDateLabel.padding(.horizontal, 4)
			}
			.font(.caption)
			.foregroundStyle(Color.theme.secondaryText)
			.onAppear {
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
					// my oga Nick used .linear, me weh get stubborn head wan use .spring, comman beat me nna
					withAnimation(.spring(duration: 2)) {
						percentage = 1
					}
				}
			}
    }
}

//#Preview {
//    ChartView()
//}

extension ChartView {
	
	private var chartDateLabel: some View {
		HStack {
			Text(startingDate.asShortDateString())
			 Spacer()
			Text(endingDate.asShortDateString())
		}
	}
	
	private var chartYAxis: some View {
		VStack{
			Text(maxY.formattedWithAbbreviations())
			Spacer()
			Text(((maxY + minY) / 2).formattedWithAbbreviations())
			Spacer()
			Text(minY.formattedWithAbbreviations())
		}
	}
	
	private var chartBg: some View {
		VStack{
			Divider()
			Spacer()
			Divider()
			Spacer()
			Divider()
			Spacer()
		}
	}
	
	private var chartView: some View {
		
		// 300 UI screen width
		// 100 items
		// 3 is the x position,
		// 1 * 3 = 3
		// 2 * 3 = 6
		// 3 * 3 = 9
		// 100 * 3 = 300
		
		// 60,000 => maxY
		// 50,000 => minY
		// 60,000 - 50,000 = 10,000 => yAxis
		// say we wanna find 52,000 after 50,000, i.e 52,000 - 50,000 = 2,000,
		// dividing the 2,000 / 10,000 (yAxis), = 20%, meaning 52k will just take 20% on the yAxis
		GeometryReader { geo in
			Path{ path in
				for index in data.indices {
					// Using the screen size, and later add a padding to the design with throw our data mapping off, hence the need for the geometry reader.
//						let xPosition = UIScreen.main.bounds.width / CGFloat(data.count) * CGFloat(index + 1)
					let xPosition = geo.size.width / CGFloat(data.count) * CGFloat(index + 1)
					
					let yAxis = maxY - minY
//						let yPosition = CGFloat((data[index] - minY) / yAxis) * geo.size.height
					// This height is that of the geometry reader, as a way to detect the height of the container...
					// Based on our dev.coin data we used (from the PreviewExtension), our price is going high, but based on the device axis markings, the x=0, y=0, starts from the top left, hence we need to reverse our calculations to cater for that
					let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geo.size.height
					
					
					if index == 0 {
						path.move(to: CGPoint(x: xPosition, y: yPosition))
					}
					path.addLine(to: CGPoint(x: xPosition, y: yPosition))
				}
				
			}
			// adding an animation as the chart comes unto the screen
//			.trim(from: 0, to: 0.5)  This will only show(trim) half of the chart
			.trim(from: 0, to: percentage)
			.stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
			.shadow(color: lineColor, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 0, y: 10)
			.shadow(color: lineColor.opacity(0.5), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 0, y: 20)
			.shadow(color: lineColor.opacity(0.2), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 0, y: 30)
			.shadow(color: lineColor.opacity(0.1), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 0, y: 40)
		}
	}
}


struct ChartView_preview: PreviewProvider {
	
	static var previews: some View {
		ChartView(coin: dev.coin)
	}
}
