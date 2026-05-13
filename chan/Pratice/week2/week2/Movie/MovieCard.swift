import SwiftUI

struct MovieCard: View {
    // 1. 모델 데이터 선언
    let movieInfo: MovieModel
    
    // 2. 초기화 함수 (직접 작성하신 버전)
    init(movieInfo: MovieModel) {
        self.movieInfo = movieInfo
    }
    
    var body: some View {
        VStack(spacing: 5) {
            // 영화 이미지 (모델에 Image 타입으로 들어있어서 바로 사용)
            movieInfo.movieImage
                .resizable() // 크기 조절 가능하게
                .scaledToFit() // 비율 유지
            
            // 영화 제목
            Text(movieInfo.movieName)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Color.black)
            
            // 하단 정보 (좋아요 & 예매율)
            HStack {
                movieLike // 아래 정의한 하트 뷰
                
                Spacer()
                
                Text("예매율 \(String(format: "%.1f", movieInfo.movieReserCount))%")
                    .font(.system(size: 9, weight: .regular))
                    .foregroundStyle(Color.black)
            }
        }
        // 피그마 기준 고정 사이즈 설정
        .frame(width: 120, height: 216)
    }
    
    /// 하단 영화 좋아요 뷰 (컴포넌트 분리)
    private var movieLike: some View {
        HStack(spacing: 6) {
            Image(systemName: "heart.fill")
                .foregroundStyle(Color.red)
                .frame(width: 15, height: 14)
            
            Text("\(movieInfo.movieLike)")
                .font(.system(size: 9, weight: .regular))
                .foregroundStyle(Color.black)
        }
    }
}

// MARK: - 미리보기 (유령 문자 제거됨)
#Preview {
    MovieCard(movieInfo: MovieModel(
        movieImage: Image(.kingsWarden),
        movieName: "왕과 사는 남자",
        movieLike: 972,
        movieReserCount: 30.8
    ))
}
