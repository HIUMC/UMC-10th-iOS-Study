import Foundation

struct TokenInfo: Codable, Equatable, Sendable {
    let accessToken: String
    let refreshToken: String?
    let tokenType: String
    let expiresIn: Int?
    let refreshTokenExpiresIn: Int?
    let issuedAt: Date
}
