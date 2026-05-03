import Foundation

struct APIResponse: Codable {
    let status: String
    let message: String
    let data: UserData
}

struct UserData: Codable {
    let users: [UserDTO]
}

struct UserDTO: Codable {
    let userId: String
    let name: String
    let profileImage: String?
    let userBio: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case name = "user_name"
        case profileImage = "profile_image"
        case userBio = "user_bio"
        case createdAt = "created_at"
    }
}

extension UserDTO {
    func toDomain() -> UserModel {
        UserModel(
            id: userId,
            name: name,
            profileImageURL: profileImage,
            bio: userBio
        )
    }
}
