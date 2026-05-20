import SwiftUI

struct MovieSearchView: View {
    @StateObject private var vm: MovieSearchViewModel
    let onSelect: (ReservationModel) -> Void

    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]

    init(movies: [ReservationModel], onSelect: @escaping (ReservationModel) -> Void) {
        _vm = StateObject(wrappedValue: MovieSearchViewModel(movies: movies))
        self.onSelect = onSelect
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 14) {
                TextField("영화명을 입력하세요", text: $vm.query)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 20)

                if vm.isLoading {
                    ProgressView("검색중...")
                }

                if let errorMessage = vm.errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundStyle(.red)
                }

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 18) {
                        ForEach(vm.results) { movie in
                            Button {
                                onSelect(movie)
                            } label: {
                                VStack(alignment: .leading, spacing: 8) {
                                    movie.movieImage
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 150)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))

                                    Text(movie.title)
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.primary)
                                        .lineLimit(2)

                                    Text(String(format: "%.1f", movie.rate))
                                        .font(.caption2)
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color.megaPurple)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                }
            }
            .padding(.top, 16)
            .navigationTitle("영화 검색")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    MovieSearchView(
        movies: [
            .init(posterName: "kingsWarden", title: "왕과 사는 남자", rate: 4.8),
            .init(posterName: "project", title: "프로젝트 헤일메리", rate: 4.6)
        ],
        onSelect: { _ in }
    )
}
