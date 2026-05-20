import Foundation
import Moya

extension MoyaProvider {
    func requestAsync(_ target: Target) async throws -> Response {
        try await withCheckedThrowingContinuation { continuation in
            request(target) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
