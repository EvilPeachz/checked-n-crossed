import SwiftData
import SwiftUI

@main
struct CrossedApp: App {
    @StateObject private var authService = AuthService()
    @StateObject private var purchaseService = PurchaseService()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            UserProfile.self,
            TaskItem.self,
            TaskOccurrence.self
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Unable to build model container: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if authService.currentUser == nil {
                    AuthView()
                } else {
                    MainListView()
                }
            }
            .environmentObject(authService)
            .environmentObject(purchaseService)
            .dynamicTypeSize(.xSmall ... .accessibility5)
        }
        .modelContainer(sharedModelContainer)
    }
}
