import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var purchaseService: PurchaseService

    var body: some View {
        Form {
            Section("Account") {
                Label(purchaseService.hasPro ? "Pro Active" : "Free Plan", systemImage: purchaseService.hasPro ? "crown.fill" : "person")
            }

            Section("Subscriptions") {
                NavigationLink("Upgrade") { UpgradeView().environmentObject(purchaseService) }
            }
        }
        .navigationTitle("Settings")
    }
}
