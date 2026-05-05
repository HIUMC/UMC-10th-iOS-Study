import SwiftUI


actor NetworkManager {
    func getUserData() async throws -> String {
        var urlComponents = URLComponents(string: "http://localhost:8080/person")!
        urlComponents.queryItems = [
            URLQueryItem(name: "name", value: "소피")
        ]
        
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        guard let responseString = String(data: data, encoding: .utf8) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        return responseString
    }
}

let networkManager = NetworkManager()

Task {
    do {
        let result = try await networkManager.getUserData()
        print("응답 데이터:", result)
    } catch {
        print("네트워크 에러", error)
    }
}
