//
//  DataController-StoreKit.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 9/20/26.
//

import Combine
import Foundation
import StoreKit

extension DataController {
	/// The product ID for our premium unlock.
	static let unlockPremiumProductID = "Cardona.Figueroa.Hector.HabitsTracker.PremiumUnlock"

	/// Loads and saves whether our premium unlock has been purchased.
	var fullVersionUnlocked: Bool {
		get {
			defaults.bool(forKey: "fullVersionUnlocked")
		}

		set {
			defaults.set(newValue, forKey: "fullVersionUnlocked")
		}
	}

	/// Monitors for past or future purchases made.
	func monitorTransactions() async {
		// Check for previous purchases.
		for await entitlement in Transaction.currentEntitlements {
			if case let .verified(transaction) = entitlement {
				await finalize(transaction)
			}
		}

		// Watch for future transactions coming in.
		for await update in Transaction.updates {
			if let transaction = try? update.payloadValue {
				await finalize(transaction)
			}
		}
	}

	/// Try's to make the purchase of a product.
	/// - Parameter product: The product being bought.
	func purchase(_ product: Product) async throws {
		let result = try await product.purchase()

		if case let .success(validation) = result {
			try await finalize(validation.payloadValue)
		}
	}

	/// Finalizes a purchase made by unlocking the product bought.
	/// - Parameter transaction: The transaction made past or present.
	@MainActor
	func finalize(_ transaction: Transaction) async {
		if transaction.productID == Self.unlockPremiumProductID {
			objectWillChange.send()
			fullVersionUnlocked = transaction.revocationDate == nil
			await transaction.finish()
		}
	}

	/// Loads an Array of products to be shown in the store.
	@MainActor
	func loadProducts() async throws {
		guard products.isEmpty else { return }

		try await Task.sleep(for: .seconds(0.2))
		products = try await Product.products(for: [Self.unlockPremiumProductID])
	}
}
