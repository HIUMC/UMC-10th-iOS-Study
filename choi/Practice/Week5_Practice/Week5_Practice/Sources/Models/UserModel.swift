import Foundation

struct UserModel: Identifiable, Equatable {
    let id: String
    let name: String
    let profileImageURL: String?
    let bio: String

    var isProfileComplete: Bool {
        !name.isEmpty && !bio.isEmpty
    }

    var displayName: String {
        name.isEmpty ? "익명 사용자" : name
    }
}
