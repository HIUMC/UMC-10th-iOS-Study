//
//  MovieSearchViewModel.swift
//  Week4
//
//  Created by 김민지 on 4/8/26.
//

import SwiftUI
import Combine

final class MovieSearchViewModel: ObservableObject {
    private let model: [MovieModel] = [
        .init(movieImage: .init(.kingsWarden), title: "왕과 사는 남자", rate: 4.8),
        .init(movieImage: .init(.project), title: "프로젝트 헤일메리", rate: 4.6),
        .init(movieImage: .init(.hoppers), title: "호퍼스", rate: 4.1),
        .init(movieImage: .init(.humint), title: "휴민트", rate: 3.8),
        .init(movieImage: .init(.madDance), title: "매드 댄스 오피스", rate: 3.9),
        .init(movieImage: .init(.method), title: "메소드 연기", rate: 4.2),
        .init(movieImage: .init(.years), title: "28년 후", rate: 3.7)
    ]
    @Published var query: String = ""
    @Published var results: [MovieModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var bag = Set<AnyCancellable>()
    
    init() {
        $query
            .debounce(for: .milliseconds(350), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.errorMessage = nil
            })
            .flatMap { query in
                self.search(query: query)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let err) = completion {
                    self?.errorMessage = "검색 실패: \(err.localizedDescription)"
                    self?.results = []
                }
            } receiveValue: { [weak self] items in
                self?.results = items
            }
            .store(in: &bag)
    }

    private func search(query: String) -> AnyPublisher<[MovieModel], Error> {
        return Future<[MovieModel], Error> { [weak self] promise in
            let delay = Double(Int.random(in: 300...700)) / 1000.0
            guard let self else { return }
            
            DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
                let filtered = self.model.filter { $0.title.lowercased().contains(query) }
                promise(.success(filtered))
            }
        }
        .handleEvents(
            receiveSubscription: { _ in
                DispatchQueue.main.async {
                    self.isLoading = true
                }
            },
            receiveCompletion: { _ in
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        )
        .eraseToAnyPublisher()
    }
}


