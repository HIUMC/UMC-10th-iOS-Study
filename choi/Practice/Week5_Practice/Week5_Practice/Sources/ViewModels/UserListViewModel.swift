import Foundation
import Observation

@MainActor
@Observable
final class UserListViewModel {
    var users: [UserModel]
    var isLoading = false
    var errorMessage: String?

    private var userStore: [UserModel]

    init(users: [UserModel] = UserListViewModel.defaultUsers) {
        self.users = users
        self.userStore = users
    }

    static var mockDataPreview: UserListViewModel {
        let users = (try? loadUsersFromMockData()) ?? defaultUsers
        return UserListViewModel(users: users)
    }

    private static let defaultUsers: [UserModel] = [
        UserModel(
            id: "preview-1",
            name: "Sophie",
            profileImageURL: nil,
            bio: "iOS Developer"
        ),
        UserModel(
            id: "preview-2",
            name: "David",
            profileImageURL: nil,
            bio: "Backend Developer"
        )
    ]

    func fetchUsers() async {
        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            userStore = try Self.loadUsersFromMockData()
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

    private static func loadUsersFromMockData(bundle: Bundle = .main) throws -> [UserModel] {
        guard let url = bundle.url(forResource: "MockData", withExtension: "json") else {
            throw UserListError.mockDataNotFound
        }

        let data = try Data(contentsOf: url)
        let response = try JSONDecoder().decode(APIResponse.self, from: data)
        return response.data.users.map { $0.toDomain() }
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
