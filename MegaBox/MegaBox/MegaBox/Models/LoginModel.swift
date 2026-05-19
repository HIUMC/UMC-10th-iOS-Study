//
//  LoginModel.swift
//  MegaBox
//
//  Created by 김민지 on 4/1/26.
//

import Foundation
import Security

struct LoginModel {
    var id: String = ""
    var pwd: String = ""
}
// let은 상수로 한 번 값이 정해지면 바꿀 수 없음 

enum AppStorageKeys {
    static let userName = "savedName"
}

struct LoginCredential: Codable {
    let id: String
    let password: String
    let userName: String
}

final class CredentialService {
    static let shared = CredentialService()

    private init() {}

    private let account = "loginCredential"
    private let service = "com.megabox.credentialInfo"

    @discardableResult
    private func saveCredentialInfo(_ credential: LoginCredential) -> OSStatus {
        do {
            let data = try JSONEncoder().encode(credential)

            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: account,
                kSecAttrService as String: service,
                kSecValueData as String: data,
                kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
            ]

            SecItemDelete(query as CFDictionary)

            return SecItemAdd(query as CFDictionary, nil)
        } catch {
            print("Credential JSON 인코딩 실패: \(error)")
            return errSecParam
        }
    }

    private func loadCredentialInfo() -> LoginCredential? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        if status == errSecItemNotFound {
            return nil
        }

        guard status == errSecSuccess, let data = item as? Data else {
            print("키체인 로그인 정보 불러오기 실패 - status: \(status)")
            return nil
        }

        do {
            return try JSONDecoder().decode(LoginCredential.self, from: data)
        } catch {
            print("Credential JSON 디코딩 실패: \(error)")
            return nil
        }
    }

    @discardableResult
    private func deleteCredentialInfo() -> OSStatus {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service
        ]

        return SecItemDelete(query as CFDictionary)
    }

    @discardableResult
    func saveCredential(_ credential: LoginCredential) -> Bool {
        let status = saveCredentialInfo(credential)
        if status != errSecSuccess {
            print("키체인 로그인 정보 저장 실패 - status: \(status)")
        }
        return status == errSecSuccess
    }

    func loadCredential() -> LoginCredential? {
        loadCredentialInfo()
    }

    @discardableResult
    func deleteCredential() -> Bool {
        let status = deleteCredentialInfo()
        if status != errSecSuccess && status != errSecItemNotFound {
            print("키체인 로그인 정보 삭제 실패 - status: \(status)")
        }
        return status == errSecSuccess || status == errSecItemNotFound
    }
}
