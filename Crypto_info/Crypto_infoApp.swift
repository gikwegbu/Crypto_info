//
//  Crypto_infoApp.swift
//  Crypto_info
//
//  Created by gikwegbu on 06/08/2024.
//

import SwiftUI

@main
struct Crypto_infoApp: App {
	@StateObject private var HomeVM: HomeViewModel = HomeViewModel()
	
    var body: some Scene {
        WindowGroup {
					NavigationView(content: {
						HomeView()
							.toolbar(.hidden)
							.environmentObject(HomeVM)
					}) 
        }
    }
}
