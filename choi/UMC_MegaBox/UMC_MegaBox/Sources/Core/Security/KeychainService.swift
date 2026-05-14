import Foundation
import Security

enum KeychainServiceError: Error, LocalizedError {
    case itemNotFound
    case invalidData
    case unhandledStatus(OSStatus)

    var errorDescription: String? {
        switch self {
        case .itemNotFound:
            return "Keychain item was not found."
        case .invalidData:
            return "Keychain item data is invalid."
        case .unhandledStatus(let status):
            return "Keychain operation failed with status: \(status)."
        }
    }
}

final class KeychainService {
    static let shared = KeychainService()

    private init() {}

    func save(_ data: Data, account: String, service: String) throws {
        var query = baseQuery(account: account, service: service)
        SecItemDelete(query as CFDictionary)

        query[kSecValueData as String] = data
        query[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly

        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainServiceError.unhandledStatus(status)
        }
    }

    func load(account: String, service: String) throws -> Data {
        var query = baseQuery(account: account, service: service)
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status != errSecItemNotFound else {
            throw KeychainServiceError.itemNotFound
        }
        guard status == errSecSuccess else {
            throw KeychainServiceError.unhandledStatus(status)
        }
        guard let data = item as? Data else {
            throw KeychainServiceError.invalidData
        }
        return data
    }

    @discardableResult
    func delete(account: String, service: String) -> OSStatus {
        let query = baseQuery(account: account, service: service)
        return SecItemDelete(query as CFDictionary)
    }

    private func baseQuery(account: String, service: String) -> [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service
        ]
    }
}
