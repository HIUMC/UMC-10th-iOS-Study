import SwiftUI

struct MovieDetailView: View {
    let movie: MovieModel
    @State private var selectedTab: Int = 0
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                // 포스터
                Image(movie.posterImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .frame(height: 350)
                    .clipped()

                // 영화 제목
                VStack(spacing: 4) {
                    Text(movie.title)
                        .font(.pretendardBold22)
                        .foregroundStyle(Color(.gray07))

                    Text(movie.englishTitle)
                        .font(.pretendardRegular13)
                        .foregroundStyle(Color(.gray03))
                }
                .padding(.top, 20)

                // 대사 인용
                Text(movie.quote)
                    .font(.pretendardMedium14)
                    .foregroundStyle(Color(.gray04))
                    .padding(.top, 16)
                    .padding(.horizontal, 20)

                // 줄거리
                Text(movie.description)
                    .font(.pretendardRegular13)
                    .foregroundStyle(Color(.gray04))
                    .lineSpacing(4)
                    .padding(.top, 8)
                    .padding(.horizontal, 20)

                // 상세정보 / 실관람평 세그먼트
                detailSegment
                    .padding(.top, 24)

                // 상세 정보 영역
                if selectedTab == 0 {
                    movieInfoSection
                        .padding(.top, 16)
                        .padding(.horizontal, 20)
                } else {
                    VStack(spacing: 20) {
                        Text("등록된 관람평이 없어요 😢")
                            .font(.pretendardMedium14)
                            .foregroundStyle(Color(.gray03))
                            .padding(.top, 40)
                    }
                }

                Spacer().frame(height: 40)
            }
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(Color(.gray07))
                }
            }
        }
    }

    // MARK: - 세그먼트

    private var detailSegment: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Button(action: { withAnimation { selectedTab = 0 } }) {
                    Text("상세 정보")
                        .font(.pretendardSemiBold16)
                        .foregroundStyle(selectedTab == 0 ? Color(.purple03) : Color(.gray03))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }

                Button(action: { withAnimation { selectedTab = 1 } }) {
                    Text("실관람평")
                        .font(.pretendardSemiBold16)
                        .foregroundStyle(selectedTab == 1 ? Color(.purple03) : Color(.gray03))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
            }

            // 하단 인디케이터
            GeometryReader { geo in
                Rectangle()
                    .fill(Color(.purple03))
                    .frame(width: geo.size.width / 2, height: 2)
                    .offset(x: selectedTab == 0 ? 0 : geo.size.width / 2)
            }
            .frame(height: 2)

            Divider()
        }
        .padding(.horizontal, 20)
    }

    // MARK: - 영화 정보

    private var movieInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            infoRow(label: "등급", value: movie.rating)
            infoRow(label: "개봉", value: movie.releaseInfo)
            infoRow(label: "장르", value: movie.genre)
            infoRow(label: "타입", value: movie.type)
            infoRow(label: "감독", value: movie.director)
            infoRow(label: "출연", value: movie.cast)
        }
    }

    private func infoRow(label: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(label)
                .font(.pretendardSemiBold13)
                .foregroundStyle(Color(.gray03))
                .frame(width: 32, alignment: .leading)

            Text(value)
                .font(.pretendardRegular13)
                .foregroundStyle(Color(.gray07))
        }
    }
}

#Preview {
    NavigationStack {
        MovieDetailView(movie: MovieModel(
            title: "왕과 사는 남자",
            posterImage: "kingsWarden",
            audienceCount: 1475,
            englishTitle: "The King's Warden",
            quote: "\"나는 이제 어디로 갈까요...\"",
            description: "계유정난이 조선을 뒤흔들고\n어린 왕 이유원은 왕위에서 쫓겨나 유배길에 오른다.",
            rating: "12세 이상 관람가",
            releaseInfo: "2026.02.04 · 개봉 · 117분",
            genre: "드라마, 사극",
            type: "2D, 2D ATMOS, 디지털영문자막",
            director: "장항준",
            cast: "유해진, 박지훈, 유지태, 전미도"
        ))
    }
}
