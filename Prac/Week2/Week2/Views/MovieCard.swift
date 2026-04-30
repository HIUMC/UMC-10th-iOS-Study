//
//  MovieCard.swift
//  Week2
//
//  Created by 김민지 on 4/1/26.
//

// 이 뷰는 좌우 버튼을 누를 때마다 모델의 값에 따라 화면에 보이는 내용이 변경됩니다.
// 즉, init()을 통해 모델을 주입하여 내부 내용이 변경될 수 있도록 해야 합니다.

import SwiftUI

import SwiftUI

struct MovieCard: View {
    
    let movieInfo: MovieModel
    

    init(movieInfo: MovieModel) {
        self.movieInfo = movieInfo
    }
    
    var body: some View {
        VStack(spacing: 5) {
            movieInfo.movieImage
            
            Text(movieInfo.movieName)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Color.black)
            
            HStack {
                movieLike
                
                Spacer()
                
                Text("예매율 \(String(format: "%.1f", movieInfo.movieReserCount))%")
                    .font(.system(size: 9, weight: .regular))
                    .foregroundStyle(Color.black)
            }
        }
        /* 상위 뷰의 프레임 고정 (HStack 내부 Spacer가 부모 사이즈에 반응하도록 설정) */
        .frame(width: 120, height: 216)
    }
    
    /// 하단 영화 좋아요 뷰
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

#Preview {
    MovieCard(movieInfo: .init(
        movieImage: Image(systemName: "popcorn.fill"), // 예시용 이미지
        movieName: "왕과 사는 남자",
        movieLike: 972,
        movieReserCount: 30.8
    ))
}
