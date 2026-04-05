//
//  MovieViewModel.swift
//  Week2
//
//  Created by 김민지 on 4/1/26.
//

import Foundation
import SwiftUI

@Observable
class MovieViewModel {

    var currentIndex: Int = 0   //인덱스 저장 변수
    
    let movieModel: [MovieModel] = [
        .init(movieImage: .init(.kingsWarden), movieName: "왕과 사는 남자", movieLike: 972, movieReserCount: 30.8),
        .init(movieImage: .init(.hoppers), movieName: "호퍼스", movieLike: 999, movieReserCount: 99.8),
        .init(movieImage: .init(.theBride), movieName: "브라이드!", movieLike: 302, movieReserCount: 24.8),
        .init(movieImage: .init(.humint), movieName: "휴민트", movieLike: 302, movieReserCount: 3.8),
        .init(movieImage: .init(.madDance), movieName: "매드 댄스 오피스", movieLike: 604, movieReserCount: 62.2),
        .init(movieImage: .init(.onceWe), movieName: "만약에 우리", movieLike: 392, movieReserCount: 43.9),
        .init(movieImage: .init(.years), movieName: "28년 후: 뼈의 사원", movieLike: 30, movieReserCount: 2.1)
    ]
    
    // 이전 영화로 돌아가기, 단, 첫 번째 영화일 경우 마지막 영화로 전환
        public func previousMovie() {
            currentIndex = (currentIndex - 1 + movieModel.count) % movieModel.count
        }
    
    // 오른쪽 버튼을 눌렀을 때 다음 영화로 이동하는 함수
    public func nextMovie() {
        currentIndex = (currentIndex + 1) % movieModel.count
    }
    
}

