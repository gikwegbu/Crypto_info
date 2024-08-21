//
//  SettingsView.swift
//  Crypto_info
//
//  Created by gikwegbu on 21/08/2024.
//

import SwiftUI

struct SettingsView: View {
	
	let defaultUrl = "https://www.google.com/search?q=george+ikwegbu"
	let youTubeUrl = "https://www.youtube.com/@georgeikwegbu5284"
	let linkedinUrl = "https://www.linkedin.com/g.ikwegbu"
	let twitterUrl = "https://www.twitter.com/g.ikwegbu"
	let coinGeckoUrl = "https://coingecko.com"
	
	
	
    var body: some View {
			NavigationView {
				List {
					appDetailsSection
					coinGeckoSection
					appDevSection
					legalDocSection
				}
			}
			.listStyle(GroupedListStyle())
			.navigationTitle("Settings")
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					BackBtn()
				}
			}
    }
}


extension SettingsView {
	private var appDetailsSection: some View {
		Section(header: Text("App details")) {
			VStack(alignment: .leading) {
				Image("logo")
					.resizable()
					.frame(width: 100, height: 100)
					.clipShape(RoundedRectangle(cornerRadius: 20))
				
				
				Text("This is really a cool app...")
					.font(.callout)
					.fontWeight(.medium)
					.foregroundStyle(Color.theme.accent)
			}
			.padding(.vertical)
			
			Text(.init("[Subscribe on YouTube](\(youTubeUrl))"))
			Text(.init("[Follow me on X](\(twitterUrl))"))
		}
	}
	
	private var coinGeckoSection: some View {
		Section(header: Text("API details")) {
			VStack(alignment: .leading) {
				Image("coingecko")
					.resizable()
					.scaledToFit()
					.frame(height: 100)
					.clipShape(RoundedRectangle(cornerRadius: 20))
				
				
				Text("This is the website where the API for the coins were gotten from, the prices may be a bit delayed")
					.font(.callout)
					.fontWeight(.medium)
					.foregroundStyle(Color.theme.accent)
			}
			.padding(.vertical)
			
			Text(.init("[Visit Coingecko](\(coinGeckoUrl))"))
		}
	}
	
	private var appDevSection: some View {
		Section(header: Text("Developer details")) {
			VStack(alignment: .leading) {
				Image("logo")
					.resizable()
					.frame(width: 100, height: 100)
					.clipShape(RoundedRectangle(cornerRadius: 20))
				
				
				Text("This app was built by George Ikwegbu, with the learning guidance of Nick Sarno, a badass tutor, learned hands down professional MVVM software architecture in SwiftUi, multi-threading, API calls with Combine and saving coin images using CoreData on this app.")
					.font(.callout)
					.fontWeight(.medium)
					.foregroundStyle(Color.theme.accent)
			}
			.padding(.vertical)
			
			Text(.init("[Google Search](\(defaultUrl))"))
			Text(.init("[X](\(twitterUrl))"))
			Text(.init("[LinkedIn](\(linkedinUrl))"))
			Text(.init("[YouTube](\(youTubeUrl))"))
		}
	}
	
	private var legalDocSection: some View {
		Section(header: Text("Legal Details")) {
			Text(.init("[Terms of Service](\(defaultUrl))"))
			Text(.init("[Privacy Policy](\(defaultUrl))"))
			Text(.init("[Company Website](\(defaultUrl))"))
			Text(.init("[Learn More](\(defaultUrl))"))
		}
	}
}

#Preview {
    SettingsView()
}
