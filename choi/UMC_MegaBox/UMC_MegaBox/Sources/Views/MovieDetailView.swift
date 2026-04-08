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
                        .font(.pretendardBold24)
                        .foregroundStyle(Color(.black))

                    Text(movie.englishTitle)
                        .font(.pretendardSemiBold14)
                        .foregroundStyle(Color(.gray03))
                }
                .padding(.top, 20)

                // 명대사와 줄거리를 묶어주는 VStack
                VStack(alignment: .leading, spacing: 8) {
                    
                    // 대사 인용
                    Text(movie.quote)
                        .font(.pretendardMedium14)
                        .foregroundStyle(Color(.gray04))
                        .multilineTextAlignment(.leading)
                    // 줄거리
                    Text(movie.description)
                        .font(.pretendardRegular13)
                        .foregroundStyle(Color(.gray04))
                        .lineSpacing(4)
                        .multilineTextAlignment(.leading) // 여러 줄일 경우 텍스트 좌측 정렬
                }
                // 가로 길이를 꽉 채우고(infinity) 요소를 왼쪽(leading)으로 밀어버림
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 16)
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
                        Button(action:{}){
                            
                        }
                        Text("등록된 관람평이 없어요 🥲")
                            .font(.pretendardSemiBold18)
                            .foregroundStyle(Color(.black))
                            .multilineTextAlignment(.center)
                            .frame(width: 408, height: 165)
                            .glassEffect(in: .rect(cornerRadius: 24.0))
                            .shadow(color: .black.opacity(0.05), radius: 24, x: 0, y: 8)
                    }
                    
                }

                Spacer().frame(height: 30)
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
                        .foregroundStyle(selectedTab == 0 ? Color(.black) : Color(.gray03))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }

                Button(action: { withAnimation { selectedTab = 1 } }) {
                    Text("실관람평")
                        .font(.pretendardSemiBold16)
                        .foregroundStyle(selectedTab == 1 ? Color(.black) : Color(.gray03))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
            }

            // 하단 인디케이터
            GeometryReader { geo in
                Rectangle()
                    .fill(Color(.black))
                    .frame(width: geo.size.width / 2, height: 2)
                    .offset(x: selectedTab == 0 ? 0 : geo.size.width / 2)
            }
            .frame(height: 2)

            Divider()
        }
        .padding(.horizontal, 20)
    }

    // MARK: - 영화 정보 섹션
    private var movieInfoSection: some View {
        // 1️⃣ 전체를 감싸는 VStack
        VStack(alignment: .leading, spacing: 0) {
            
            // 2️⃣ 상단: 포스터 이미지 + 등급/개봉 정보 (HStack)
            HStack(alignment: .top, spacing: 16) {
                // 영화 이미지
                Image(movie.posterImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 43, height: 61) // 프로젝트 규격에 맞춰 너비/높이 조절
                    .cornerRadius(8)
                
                // 영화 등급 & 개봉 정보
                VStack(alignment: .leading, spacing: 6) {
                    Text(movie.rating)
                        .font(.pretendardSemiBold14)
                        .foregroundStyle(Color(.black))
                    
                    Text(movie.releaseInfo)
                        .font(.pretendardSemiBold14)
                        .foregroundStyle(Color(.black))
                }
                .padding(.top, 10)
            }
            .padding(.bottom, 20)
            
            Divider()
                .background(Color(.gray02)) // 연한 회색
                .padding(.bottom, 20)
            
            VStack(alignment: .leading, spacing: 12) {
                infoRow(label: "장르", value: movie.genre)
                infoRow(label: "타입", value: movie.type)
                infoRow(label: "감독", value: movie.director)
                infoRow(label: "출연", value: movie.cast)
            }
        }
    }

    // MARK: - 개별 정보 Row 컴포넌트
    private func infoRow(label: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text(label)
                .font(.pretendardSemiBold13)
                .foregroundStyle(Color(.gray04))
                .frame(width: 32, alignment: .leading)

            Text(value)
                .font(.pretendardSemiBold13)
                .foregroundStyle(Color(.black))
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
