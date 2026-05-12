import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case missingAuthorizationCode
    case cancelled
    case invalidResponse
    case configuration(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "올바르지 않은 URL입니다."
        case .missingAuthorizationCode:
            return "카카오 인가 코드를 받지 못했습니다."
        case .cancelled:
            return "로그인이 취소되었습니다."
        case .invalidResponse:
            return "응답 형식이 올바르지 않습니다."
        case .configuration(let message):
            return message
        }
    }
}
