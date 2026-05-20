import Combine
import Foundation

final class MovieSearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var results: [ReservationModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let movies: [ReservationModel]
    private var bag = Set<AnyCancellable>()

    init(movies: [ReservationModel]) {
        self.movies = movies
        self.results = movies
        bind()
    }

    private func bind() {
        $query
            .debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.errorMessage = nil
            })
            .flatMap { [weak self] query -> AnyPublisher<[ReservationModel], Error> in
                guard let self else {
                    return Just([])
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                return self.search(query: query)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = "검색 실패: \(error.localizedDescription)"
                    self?.results = []
                }
            } receiveValue: { [weak self] movies in
                self?.results = movies
            }
            .store(in: &bag)
    }

    private func search(query: String) -> AnyPublisher<[ReservationModel], Error> {
        Future<[ReservationModel], Error> { [weak self] promise in
            let delay = Double(Int.random(in: 300...700)) / 1000
            guard let self else { return }

            DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
                let keyword = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                let filtered = keyword.isEmpty
                    ? self.movies
                    : self.movies.filter { $0.title.lowercased().contains(keyword) }
                promise(.success(filtered))
            }
        }
        .handleEvents(
            receiveSubscription: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.isLoading = true
                }
            },
            receiveCompletion: { [weak self] _ in
                DispatchQueue.main.async {
                    self?.isLoading = false
                }
            }
        )
        .eraseToAnyPublisher()
    }
}
