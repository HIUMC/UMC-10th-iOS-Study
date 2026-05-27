//
//  AuthViewModel.swift
//  UMC_MegaBox
//
//  Created by 최민혁 on 3/25/26.
//

import Foundation
import Observation

@MainActor
@Observable
class AuthViewModel {
    var loginModel = LoginModel()
    var currentSession: AuthSession?
    var errorMessage: String?

    @ObservationIgnored private let credentialStore: AuthCredentialStore
    @ObservationIgnored private let tokenService: TokenService
    @ObservationIgnored private let kakaoAuthService: KakaoAuthService

    init(
        credentialStore: AuthCredentialStore = .shared,
        tokenService: TokenService = .shared,
        kakaoAuthService: KakaoAuthService? = nil
    ) {
        self.credentialStore = credentialStore
        self.tokenService = tokenService
        self.kakaoAuthService = kakaoAuthService ?? .shared
        restoreSession()
    }

    var isLoggedIn: Bool {
        currentSession != nil
    }

    var userID: String {
        currentSession?.id ?? ""
    }

    var displayName: String {
        guard let currentSession else { return "" }
        return currentSession.name.isEmpty ? currentSession.id : currentSession.name
    }

    // MARK: - 로그인
    func login() {
        let id = loginModel.id.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = loginModel.pwd

        guard !id.isEmpty, !password.isEmpty else {
            errorMessage = "아이디와 비밀번호를 입력해주세요."
            return
        }

        let session = AuthSession(
            id: id,
            password: password,
            name: id,
            provider: .password
        )

        do {
            try credentialStore.save(session)
            clearLegacyUserDefaults()
            currentSession = session
            errorMessage = nil
            print("Keychain 로그인 저장 성공 - ID: \(id)")
        } catch {
            errorMessage = "키체인 저장 실패: \(error.localizedDescription)"
            print("Keychain 로그인 저장 실패:", error)
        }
    }

    func loginWithKakao() async {
        do {
            let result = try await kakaoAuthService.login()
            try tokenService.saveToken(result.tokenInfo)

            let session = AuthSession(
                id: "kakao_\(result.user.id)",
                password: nil,
                name: result.user.displayName,
                provider: .kakao
            )

            try credentialStore.save(session)
            clearLegacyUserDefaults()
            currentSession = session
            errorMessage = nil
            print("카카오 REST 로그인 성공 - ID: \(session.id)")
        } catch {
            errorMessage = error.localizedDescription
            print("카카오 REST 로그인 실패:", error)
        }
    }

    func updateName(_ name: String) {
        guard var session = currentSession else { return }
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        session.name = trimmedName

        do {
            try credentialStore.save(session)
            currentSession = session
            errorMessage = nil
        } catch {
            errorMessage = "이름 저장 실패: \(error.localizedDescription)"
        }
    }

    // MARK: - 로그아웃
    func logout(container: DIContainerProtocol) {
        container.resetAll()
        credentialStore.delete()
        tokenService.deleteToken()
        do {
            try ProfileImageStore().delete()
        } catch {
            print("프로필 이미지 삭제 실패:", error)
        }
        clearLegacyUserDefaults()
        loginModel = LoginModel()
        currentSession = nil
        errorMessage = nil
    }

    private func restoreSession() {
        if let session = try? credentialStore.load() {
            currentSession = session
            return
        }

        migrateLegacyUserDefaultsIfNeeded()
    }

    private func migrateLegacyUserDefaultsIfNeeded() {
        let defaults = UserDefaults.standard
        guard defaults.bool(forKey: "isLoggedIn") else { return }

        let id = defaults.string(forKey: "id") ?? ""
        guard !id.isEmpty else {
            clearLegacyUserDefaults()
            return
        }

        let password = defaults.string(forKey: "pwd")
        let name = defaults.string(forKey: "name").flatMap { $0.isEmpty ? nil : $0 } ?? id
        let session = AuthSession(id: id, password: password, name: name, provider: .password)

        do {
            try credentialStore.save(session)
            currentSession = session
            clearLegacyUserDefaults()
        } catch {
            errorMessage = "기존 로그인 정보 이전 실패: \(error.localizedDescription)"
        }
    }

    private func clearLegacyUserDefaults() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "id")
        defaults.removeObject(forKey: "pwd")
        defaults.removeObject(forKey: "name")
        defaults.removeObject(forKey: "isLoggedIn")
    }
}
