import Foundation

struct AuthSession: Codable, Equatable, Sendable {
    enum Provider: String, Codable, Sendable {
        case password
        case kakao
    }

    var id: String
    var password: String?
    var name: String
    var provider: Provider
}

final class AuthCredentialStore {
    static let shared = AuthCredentialStore()

    private let keychain: KeychainService
    private let account = "authSession"
    private let service = "com.minheuk.UMC-MegaBox.authSession"

    init(keychain: KeychainService = .shared) {
        self.keychain = keychain
    }

    func save(_ session: AuthSession) throws {
        let data = try JSONEncoder().encode(session)
        try keychain.save(data, account: account, service: service)
    }

    func load() throws -> AuthSession {
        let data = try keychain.load(account: account, service: service)
        return try JSONDecoder().decode(AuthSession.self, from: data)
    }

    @discardableResult
    func delete() -> OSStatus {
        keychain.delete(account: account, service: service)
    }
}
