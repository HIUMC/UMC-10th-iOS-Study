import UIKit
import AuthenticationServices

final class AuthPresentationContext: NSObject, ASWebAuthenticationPresentationContextProviding {

    static let shared = AuthPresentationContext()

    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {

        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }) else {
                fatalError("No active windowScene")
        }

        return ASPresentationAnchor(windowScene: windowScene)
    }
}
