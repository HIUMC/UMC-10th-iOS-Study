import Foundation
import Security

class KeychainService {
    // 어디서든 'KeychainService.shared'로 접근 가능하게 만듭니다. (싱글톤)
    static let shared = KeychainService()
    
    private init() {} // 외부에서 인스턴스를 직접 생성하지 못하게 막습니다.
    
    /// 1. 데이터 저장 (비밀번호, 토큰 등)
    @discardableResult
    func save(account: String, service: String, value: String) -> OSStatus {
        guard let data = value.data(using: .utf8) else {
            return errSecParam
        }

        // 쿼리 설정: 어떤 종류(Class)인지, 누구의 것(Account)인지, 어떤 앱(Service)인지 정의
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked // 폰이 열려있을 때만 접근 가능
        ]

        // 기존에 같은 데이터가 있다면 삭제 (중복 방지)
        SecItemDelete(query as CFDictionary)

        // 새로운 데이터 추가
        let status = SecItemAdd(query as CFDictionary, nil)
        return status
    }

    /// 2. 데이터 불러오기
    func load(account: String, service: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service,
            kSecReturnData as String: true,           // 실제 데이터(Value)를 돌려달라
            kSecMatchLimit as String: kSecMatchLimitOne // 딱 하나만 찾아달라
        ]

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        if status == errSecSuccess, let data = item as? Data {
            return String(data: data, encoding: .utf8)
        }
        
        return nil // 데이터를 찾지 못했을 때
    }

    /// 3. 데이터 삭제 (로그아웃 시 필수)
    @discardableResult
    func delete(account: String, service: String) -> OSStatus {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: account,
            kSecAttrService as String: service
        ]

        let status = SecItemDelete(query as CFDictionary)
        return status
    }
}
