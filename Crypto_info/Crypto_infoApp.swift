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
	@State private var showLaunchView: Bool = true
	// Changing the Navigation Bar color
	
	init() {
		UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
		
		UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
		
		UITableView.appearance().backgroundColor = UIColor.clear // Since ListRows are being built with the Table view, so clearing the color, makes it match our dark mode 
		
		UINavigationBar.appearance().tintColor = UIColor(Color.theme.accent) // For the navigation back buttons
	}
	
    var body: some Scene {
        WindowGroup {
					ZStack {
						NavigationView{
							HomeView()
								.toolbar(.hidden)
								
						}
						.navigationViewStyle(StackNavigationViewStyle()) // this is for iPads
						.environmentObject(HomeVM)
						
						ZStack {
							// Using the ZStack to counter the anormally when transitioning.
							if showLaunchView {
								LaunchView(showLaunchView: $showLaunchView)
									.transition(.move(edge: .leading))
							}
						}
						.zIndex(2) // Adding a higher hierarchy
					}
        }
    }
}
