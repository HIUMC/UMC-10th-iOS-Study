import Foundation
import Observation

@MainActor
@Observable
final class UserListViewModel {
    var users: [UserModel] = []
    var isLoading = false
    var errorMessage: String?

    private var userStore: [UserModel] = []

    func fetchUsers() async {
        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            guard let url = Bundle.main.url(forResource: "MockData", withExtension: "json") else {
                throw UserListError.mockDataNotFound
            }

            let data = try Data(contentsOf: url)
            let response = try JSONDecoder().decode(APIResponse.self, from: data)
            userStore = response.data.users.map { $0.toDomain() }
            users = userStore
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func addUser(name: String, bio: String) {
        let newUser = UserModel(
            id: UUID().uuidString,
            name: name,
            profileImageURL: nil,
            bio: bio
        )

        userStore.append(newUser)
        users = userStore
    }

    func updateUser(id: String, name: String, bio: String) {
        guard let index = userStore.firstIndex(where: { $0.id == id }) else { return }

        userStore[index] = UserModel(
            id: id,
            name: name,
            profileImageURL: userStore[index].profileImageURL,
            bio: bio
        )
        users = userStore
    }

    func deleteUser(id: String) {
        userStore.removeAll { $0.id == id }
        users = userStore
    }
}

private enum UserListError: LocalizedError {
    case mockDataNotFound

    var errorDescription: String? {
        switch self {
        case .mockDataNotFound:
            return "MockData.json 파일을 찾을 수 없습니다."
        }
    }
}
