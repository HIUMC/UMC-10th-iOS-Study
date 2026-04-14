//
//  MovieSearchView.swift
//  MegaBox
//
//  Created by 김민지 on 4/8/26.
//

import Foundation
import Combine

@Observable
class MovieSearchViewModel {

    // 검색 상태

    var query: String = "" {
        didSet { querySubject.send(query) }
    }
    var filteredMovies: [MovieModel] = []
    var errorMessage: String? = nil

    // 데이터

    private let allMovies: [MovieModel]

    // Combine

    private let querySubject = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()

    // Init

    init(movies: [MovieModel]) {
        self.allMovies = movies
        self.filteredMovies = movies
        setupSearchPipeline()
    }

    // Combine 검색 파이프라인

    private func setupSearchPipeline() {
        querySubject
            .debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.errorMessage = nil
            })
            .flatMap { [weak self] query -> Just<[MovieModel]> in
                guard let self else { return Just([]) }
                return Just(self.search(query: query))
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movies in
                self?.filteredMovies = movies
            }
            .store(in: &cancellables)
    }

    // 검색 로직

    private func search(query: String) -> [MovieModel] {
        if query.trimmingCharacters(in: .whitespaces).isEmpty {
            return allMovies
        }

        return allMovies.filter {
            $0.title.localizedCaseInsensitiveContains(query) ||
            $0.englishTitle.localizedCaseInsensitiveContains(query)
        }
    }
}
