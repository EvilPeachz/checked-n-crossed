import StoreKit
import SwiftUI

struct UpgradeView: View {
    @EnvironmentObject var purchaseService: PurchaseService

    var body: some View {
        NavigationStack {
            List {
                Section("Unlock Pro") {
                    Text("Priorities")
                    Text("Due dates")
                    Text("Recurring tasks")
                    Text("Daily auto-move")
                    Text("Multi-column layouts")
                    Text("Swipe date navigation")
                }

                Section("Plans") {
                    ForEach(purchaseService.products, id: \.id) { product in
                        Button("\(product.displayName) – \(product.displayPrice)") {
                            Task { await purchaseService.purchase(product) }
                        }
                    }
                }

                Section {
                    Button("Restore Purchases") {
                        Task { await purchaseService.restorePurchases() }
                    }
                }
            }
            .navigationTitle("Upgrade to Pro")
            .task {
                await purchaseService.loadProducts()
            }
        }
    }
}
