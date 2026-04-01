//
//  MovieSpecView.swift
//  leehan
//
//  Created by 이한결 on 4/1/26.
//

import SwiftUI

struct MovieSpecView: View {
    var spec: MovieModel
    @State private var isInfoClicked: Bool = true
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                Text(spec.movieName)
                    .font(.PretendardSemiBold(size: 17))
                    .foregroundStyle(.black)
                
                Image("image_kingsWarden")
                    .frame(maxWidth: .infinity)
                
                Text(spec.movieName)
                    .font(.PretendardBold(size: 24))
                    .foregroundStyle(.black)
                
                Text(spec.movieEngName)
                    .font(.PretendardSemiBold(size: 14))
                    .foregroundStyle(.gray03)
                    .padding(.bottom, 5)
                
                Text(spec.movieDescription)
                    .lineSpacing(3)
                    .font(.PretendardRegular(size: 15))
                    .foregroundStyle(.gray03)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, 25)
                    
                VStack {
                    HStack(spacing: 0) {
                        Button2(text: "상세정보",
                                onTap: {isInfoClicked = true},
                                isInfoClicked: self.isInfoClicked)
                        Button2(text: "실관람평",
                                onTap: {isInfoClicked = false},
                                isInfoClicked: !self.isInfoClicked)
                    }
                    
                    if (isInfoClicked) {
                        InfoPage(spec: spec)
                    } else {
                        VStack {
                            Text("등록된 관람평이 없습니다.")
                        }.frame(height: 210)
                        
                    }
                }
            }
        }
        
    }
}

#Preview {
    MovieSpecView(spec: MovieModel(
        moviePoster: "movie_kingsWarden",
        movieName: "왕과 사는 남자",
        movieViews: 1500,
        movieImage: "image_kingsWarden",
        movieEngName: "The King's Warden",
        movieDescription: """
        “나는 이제 어디로 갑니까...”
        
        계유정난이 조선을 뒤흔들고
        어린 왕 이홍위는 왕위에서 쫓겨나 유배길에 오른다.
        “무슨 수를 쓰더라도 그 대감을 우리 광천골로 오게 해야지”
        한편, 강원도 영월 산골 마을 광천골의 촌장 엄흥도는 먹고 살기
        힘든 마을 사람들을 위해 청령포를 유배지로 만들기 위해 노력한다.
        그러나 촌장이 부푼 꿈으로 맞이한 이는 왕위에서 쫓겨난 이홍위였다.
        유배지를 지키는 보수주인으로서 그의 모든 일상을 감시해야만 하는
        촌장은 삶의 의지를 잃어버린 이홍위가 점점 신경 쓰이는데...
        
        1457년 청령포, 역사가 지우려 했던 이야기.
        """,
        age: "12세 이상 관람가",
        opening: "2026.02.04.",
        time: "117분",
        genre: "드라마, 사극",
        type: "2D, 2D ATMOS, 디지털영문자막",
        director: "장항준",
        actors: "유해진, 박지훈, 유지태, 전미도, 김민, 박지환, 이준혁, 안재홍"
    ))
}
