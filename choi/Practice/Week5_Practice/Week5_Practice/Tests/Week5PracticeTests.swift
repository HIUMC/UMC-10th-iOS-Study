import Foundation
import Testing
@testable import Week5_Practice

struct Week5PracticeTests {
    @Test func decodesUserResponseAndMapsToDomain() throws {
        let jsonData = """
        {
            "status": "success",
            "message": "User list fetched successfully",
            "data": {
                "users": [
                    {
                        "user_id": "1",
                        "user_name": "Sophie",
                        "profile_image": "https://example.com/sophie.jpg",
                        "user_bio": "iOS Developer",
                        "created_at": "2025-01-01T10:00:00Z"
                    }
                ]
            }
        }
        """.data(using: .utf8)!

        let response = try JSONDecoder().decode(APIResponse.self, from: jsonData)
        let user = try #require(response.data.users.first?.toDomain())

        #expect(user.id == "1")
        #expect(user.displayName == "Sophie")
        #expect(user.bio == "iOS Developer")
        #expect(user.isProfileComplete)
    }
}
