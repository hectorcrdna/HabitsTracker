//
//  StoreView.swift
//  HabitsTracker
//
//  Created by Hector Cardona on 9/20/26.
//

import StoreKit
import SwiftUI

struct StoreView: View {
	@EnvironmentObject var dataController: DataController
	@Environment(\.dismiss) var dismiss
	@State private var products = [Product]()

    var body: some View {
		NavigationStack {
			if let product = products.first {
				VStack(alignment: .leading) {
					Text(product.displayName)
						.font(.title)

					Text(product.description)

					Button("Buy Now") {
						purchase(product)
					}
				}
			}
		}
		.onChange(of: dataController.fullVersionUnlocked) {
			checkForPurchase()
		}
		.task {
			await load()
		}
    }

	/// Checks if the full version of the app has been bought to dismiss the view.
	func checkForPurchase() {
		if dataController.fullVersionUnlocked {
			dismiss()
		}
	}

	/// Starts the purchasing process.
	/// - Parameter product: The product to purchase.
	func purchase(_ product: Product) {
		Task { @MainActor in
			try? await dataController.purchase(product)
		}
	}

	/// Loads all the products available for purchase.
	func load() async {
		do {
			products = try await Product.products(for: [DataController.unlockPremiumProductID])
		} catch {
			print("Failed to load products: \(error.localizedDescription)")
		}
	}
}

#Preview {
    StoreView()
}
