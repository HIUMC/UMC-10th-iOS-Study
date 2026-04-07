import SwiftUI

struct MovieSearchView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: MovieSearchViewModel
    let onMovieSelected: (MovieModel) -> Void

    init(movies: [MovieModel], onMovieSelected: @escaping (MovieModel) -> Void) {
        self._viewModel = State(initialValue: MovieSearchViewModel(movies: movies))
        self.onMovieSelected = onMovieSelected
    }

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        VStack(spacing: 0) {
            // 상단 핸들
            Capsule()
                .fill(Color(.gray02))
                .frame(width: 40, height: 5)
                .padding(.top, 8)

            // 타이틀
            Text("영화 선택")
                .font(.pretendardBold18)
                .foregroundStyle(Color(.gray07))
                .padding(.top, 12)
                .padding(.bottom, 16)

            // 영화 그리드
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.filteredMovies) { movie in
                        movieGridItem(movie)
                            .onTapGesture {
                                onMovieSelected(movie)
                                dismiss()
                            }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 80)
            }

            Spacer()

            // 하단 검색 바
            searchBar
        }
        .background(Color(.purple00))
    }

    // MARK: - 영화 그리드 아이템

    private func movieGridItem(_ movie: MovieModel) -> some View {
        VStack(spacing: 6) {
            Image(movie.posterImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 160)
                .clipped()
                .cornerRadius(8)

            Text(movie.title)
                .font(.pretendardMedium13)
                .foregroundStyle(Color(.gray07))
                .lineLimit(1)
        }
    }

    // MARK: - 검색 바

    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color(.gray03))

            TextField("영화명을 입력해주세요", text: $viewModel.query)
                .font(.pretendardMedium14)
                .foregroundStyle(Color(.gray07))
                .autocorrectionDisabled()

            Spacer()

            Button {
                // 마이크 (기능 없음, UI만)
            } label: {
                Image(systemName: "mic")
                    .foregroundStyle(Color(.gray03))
            }

            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .foregroundStyle(Color(.gray05))
                    .font(.system(size: 18, weight: .medium))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.white))
    }
}

#Preview {
    MovieSearchView(movies: []) { _ in }
}
