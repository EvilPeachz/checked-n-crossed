import AuthenticationServices
import Foundation

@MainActor
final class AuthService: ObservableObject {
    @Published var currentUser: UserProfile?

    func continueAsGuest() {
        currentUser = UserProfile(authProvider: .guest, isPro: false)
    }

    func signInWithApple(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success:
            currentUser = UserProfile(authProvider: .apple, isPro: false)
        case .failure:
            currentUser = nil
        }
    }

    func signInWithGoogle() {
        // Integrate GoogleSignIn SDK in production and exchange credential with Firebase Auth.
        currentUser = UserProfile(authProvider: .google, isPro: false)
    }
}
