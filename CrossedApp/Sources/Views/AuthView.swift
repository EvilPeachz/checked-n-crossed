import AuthenticationServices
import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authService: AuthService

    var body: some View {
        ZStack {
            LegalPadBackground()
            VStack(spacing: 16) {
                Text("Crossed")
                    .font(.largeTitle.bold())
                Text("Crossed and checked")
                    .font(.headline)

                SignInWithAppleButton(.continue) { request in
                    request.requestedScopes = [.email, .fullName]
                } onCompletion: { result in
                    authService.signInWithApple(result: result)
                }
                .frame(height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 10))

                Button("Continue with Google") {
                    authService.signInWithGoogle()
                }
                .buttonStyle(.borderedProminent)

                Button("Continue as Guest") {
                    authService.continueAsGuest()
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
    }
}
