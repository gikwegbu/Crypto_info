//
//  PortfolioDataService.swift
//  Crypto_info
//
//  Created by gikwegbu on 14/08/2024.
//

import Foundation
import CoreData

class PortfolioDataService {
	
	private let container: NSPersistentContainer
	private let containerName: String = "PortfolioContainer"
	private let entityName: String = "PortfolioEntity"
	@Published var savedEntities: [PortfolioEntity] = []
	
	init() {
		container = NSPersistentContainer(name: containerName)
		container.loadPersistentStores { ( _ , error) in
			if let error = error {
				print("Error loading Core Data!: \(error)")
			}
			self.getPortfolio()
		}
	}
	
	// MARK: Public Section
	
	func updatePortfolio(coin: CoinModel, amount: Double) {
		if let entity = savedEntities.first(where: { $0.coinId == coin.id }) {
			if amount > 0 {
				update(entity: entity, amount: amount)
			} else {
				delete(entity: entity)
			}
		} else {
			add(coin: coin, amount: amount)
		}
	}
	
	
	// MARK: Private section
	private func getPortfolio() {
		let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
		
		do {
			savedEntities = try container.viewContext.fetch(request)
			print("George, we are fetching the entities: \(savedEntities)")
		} catch let error {
			print("Error Fetching Portfolio Entities: \(error)")
		}
	}
	
	private func add(coin: CoinModel, amount: Double) {
		let entity = PortfolioEntity(context: container.viewContext)
		entity.coinId = coin.id
		entity.amount = amount
		applyChanges()
	}
	
	private func update(entity: PortfolioEntity, amount: Double) {
		entity.amount = amount
		applyChanges()
	}
	
	private func delete(entity: PortfolioEntity) {
		container.viewContext.delete(entity)
		applyChanges()
	}
	
	private func save() {
		do {
			try container.viewContext.save()
		}catch let error {
			print("Error saving to Core Data. \(error)")
		}
	}
	
	private func applyChanges() {
		save()
		getPortfolio()
		// This way we save the new coin bah, then
		// Calling the getPortfolio(), will re-fetch all the saved data and updates our 'savedEntities' array
	}
	
}
