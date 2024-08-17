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
	
	// Changing the Navigation Bar color
	
	init() {
		UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
		
		UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
	}
	
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
