//
//  MainMovieSettingButton.swift
//  week2
//
//  Created by chanhyeok on 3/24/26.
//

import SwiftUI

/*
 
 currentIndex 값으로 영화를 따와도 되는걸까?
 저장소 안에는, currentIndex 관련한게 들어가는게 아니라, 그냥 텍스트만 저장되있으면 안바뀔거같은데
 일단 viewModel을 받아와야할듯 <- 그래야 접근할 수 있으니까 (currentIndex에)
 
 1. 해당 MovieCard의 정보를 @AppStorage에 저장합니다.
 2. @AppStorage에는 영화 이름만 저장합니다.
 3. 본인이 다르게 개선하여 새롭게 시도해도 좋습니다.
 힌트 :
- ZStack으로 RoudedRenctangle을 만들고 위에 Text() 얹히기
- 또는 Text만 만들고, 패딩으로 상하좌우 여백을 늘려서 storke 주기
 */


struct MainMovieSettingButton: View{
    let movieViewModel: MovieViewModel
    init(movieViewModel: MovieViewModel) {
self.movieViewModel = movieViewModel
    }
    
    @AppStorage("mainMovie") private var mainMovie: String = "대표 영화를 설정해주세요"
    
    var body : some View{
        Button {
            mainMovie = movieViewModel.movieModel[movieViewModel.currentIndex].movieName
            print("대표 영화가 \(mainMovie)로 설정되었습니다.")
        } label : {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .frame(width:246, height: 65)
                
                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black, lineWidth: 1) 
                                    .frame(width: 246, height: 65)
                Text("대표 영화로 설정")
                    .foregroundColor(.black)
            }.frame(width: 246, height: 65)
        }
        
    }
}
