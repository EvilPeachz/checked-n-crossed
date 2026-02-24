# Crossed (Crossed and checked)

SwiftUI iOS 16+ productivity app with legal-pad visual style, SwiftData persistence, authentication options, and StoreKit 2 paywall.

## Requirements
- Xcode 15+
- iOS 16+
- Apple Developer account for Sign in with Apple and In-App Purchases
- Firebase project (for Google Sign-In + optional Firebase Auth)

## Project structure
- `CrossedApp/Sources/App`: app entry point
- `CrossedApp/Sources/Models`: SwiftData models
- `CrossedApp/Sources/Services`: sorting/scheduling/auth/purchases
- `CrossedApp/Sources/Views`: SwiftUI UI screens
- `CrossedApp/Tests/CrossedTests`: unit tests for sorting logic

## Google Sign-In configuration
1. Create a Firebase project.
2. Add an iOS app with your bundle id (`com.crossed.app` by default in the project file).
3. Download `GoogleService-Info.plist` and add it to the app target.
4. Add Google Sign-In package in Xcode:
   - `https://github.com/google/GoogleSignIn-iOS`
5. Configure URL schemes in `Info`:
   - Reversed client ID from `GoogleService-Info.plist`.
6. Replace `AuthService.signInWithGoogle()` placeholder with real Google SDK flow and (optionally) Firebase Auth credential exchange.

## Sign in with Apple configuration
1. In Apple Developer portal, enable **Sign In with Apple** capability for your app ID.
2. In Xcode target settings, add capability **Sign In with Apple**.
3. The app already uses `SignInWithAppleButton`; connect success callback to your backend/Firebase as needed.

## StoreKit product setup
Create these product identifiers in App Store Connect:
- `crossed_weekly` ($2.99)
- `crossed_monthly` ($6.99)
- `crossed_yearly` ($39.99)
- `crossed_lifetime` ($79.99)

Ensure all products are in **Ready to Submit** or approved state for production testing.

## Sandbox testing
1. In Xcode, edit scheme → Run → Options → StoreKit Configuration (optional local `.storekit`).
2. Or run against App Store sandbox with a Sandbox tester account on device.
3. Use Upgrade screen → purchase button / Restore Purchases.
4. Verify free-tier gating by using “Continue as Guest” and accessing locked features.

## Notes
- Free tier allows basic create/delete/complete.
- Pro unlocks priorities, due dates, recurring modes, move-to-next-day, layouts, and date navigation.
- Expired subscriptions should set `hasPro` false while retaining stored task data.
