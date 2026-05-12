import Foundation
import Moya

protocol TMDBMovieServicing {
    func fetchNowPlaying(request: TMDBNowPlayingRequestDTO) async throws -> TMDBNowPlayingResponseDTO
}

struct TMDBMovieService: TMDBMovieServicing {
    private let provider: MoyaProvider<TMDBAPI>

    init(provider: MoyaProvider<TMDBAPI> = MoyaProvider<TMDBAPI>()) {
        self.provider = provider
    }

    func fetchNowPlaying(request: TMDBNowPlayingRequestDTO = .init()) async throws -> TMDBNowPlayingResponseDTO {
        guard Config.tmdbAPIKey != nil else {
            throw APIError.configuration("TMDB_API_KEY를 Secret.xcconfig에 입력해주세요.")
        }

        let response = try await provider.requestAsync(.nowPlaying(request))
        let filteredResponse = try response.filterSuccessfulStatusCodes()
        return try JSONDecoder().decode(TMDBNowPlayingResponseDTO.self, from: filteredResponse.data)
    }
}
