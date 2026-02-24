import Foundation
import StoreKit

@MainActor
final class PurchaseService: ObservableObject {
    static let productIDs = [
        "crossed_weekly",
        "crossed_monthly",
        "crossed_yearly",
        "crossed_lifetime"
    ]

    @Published var products: [Product] = []
    @Published var hasPro: Bool = false

    func loadProducts() async {
        do {
            products = try await Product.products(for: Self.productIDs)
        } catch {
            products = []
        }
    }

    func purchase(_ product: Product) async {
        do {
            let result = try await product.purchase()
            if case .success(let verificationResult) = result,
               case .verified(_) = verificationResult {
                hasPro = true
            }
        } catch {
            hasPro = false
        }
    }

    func restorePurchases() async {
        do {
            try await AppStore.sync()
        } catch {
            // no-op
        }
    }
}
