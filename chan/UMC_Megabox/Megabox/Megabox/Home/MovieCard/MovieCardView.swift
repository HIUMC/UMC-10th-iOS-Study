import SwiftUI

struct MovieCardView: View {
    // ⭐️ 1. 뷰모델을 상태(State)로 들고 있습니다.
    @State private var viewModel = MovieCardViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            movieChartSelector
            movieHorizontalListView
            }
    }
    //[하위뷰] MovieChartSelector: 알약 버튼 2개 있는
    var movieChartSelector : some View{
        HStack(spacing: 10) {
            // [무비차트 버튼]
            pillButton(title: "무비차트", id: "chartMovies")
            
            // [상영예정 버튼]
            pillButton(title: "상영예정", id: "upcomingMovies")
            
            Spacer() // 왼쪽으로 밀기
        }
        .padding(.horizontal)
    }

    // [하위뷰] MovieHorizontalListView
    // 가로 스크롤 영역 (영화 카드들)
    var movieHorizontalListView : some View{
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 15) {
                // 뷰모델이 선택된 탭에 맞춰 뱉어주는 currentMovies 사용
                ForEach(viewModel.currentMovies) { movie in
                    individualCard(movie)
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 380)
    }
    
    // --- ⭐️ 알약 버튼 디자인 (함수로 분리) ---
    private func pillButton(title: String, id: String) -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                viewModel.selectedChart = id // 뷰모델의 selectedChart 변경
            }
        }) {
            Text(title)
                .font(.system(size: 14, weight: .bold))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(viewModel.selectedChart == id ? Color.black : Color.white)
                .foregroundColor(viewModel.selectedChart == id ? Color.white : Color.gray)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(viewModel.selectedChart == id ? Color.black : Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
    }

    // --- 개별 영화 카드 디자인 (함수로 분리) ---
    private func individualCard(_ movie: MovieModel) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            // 포스터
            Image(movie.posterImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 160, height: 230)
                .clipped()
            
            // 예매 버튼
            Button(action: { print("\(movie.title) 예매 클릭") }) {
                Text("바로 예매")
                    .foregroundColor(.megaPurple)
                    .frame(maxWidth: .infinity)
                    .frame(height: 36)
                    .background(Color.clear)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius:8)
                            .stroke(Color.megaPurple)
                    )
            }
            // 제목
            Text(movie.title)
                .font(.system(size: 22, weight: .bold))
                .lineLimit(1)
            
            // 관객수
            Text("누적관객수 \(movie.totalAudience)")
                .font(.system(size: 18))
                .foregroundColor(.black)
            
            
        }
        .frame(width: 160)
    }
}

#Preview {
    MovieCardView()
}
