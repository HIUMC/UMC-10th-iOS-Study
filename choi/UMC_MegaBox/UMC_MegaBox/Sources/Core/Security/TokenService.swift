import Foundation

final class TokenService {
    static let shared = TokenService()

    private let keychain: KeychainService
    private let account = "authToken"
    private let service = "com.minheuk.UMC-MegaBox.tokenInfo"

    init(keychain: KeychainService = .shared) {
        self.keychain = keychain
    }

    func saveToken(_ tokenInfo: TokenInfo) throws {
        let data = try JSONEncoder().encode(tokenInfo)
        try keychain.save(data, account: account, service: service)
    }

    func loadToken() throws -> TokenInfo {
        let data = try keychain.load(account: account, service: service)
        return try JSONDecoder().decode(TokenInfo.self, from: data)
    }

    @discardableResult
    func deleteToken() -> OSStatus {
        keychain.delete(account: account, service: service)
    }
}
