import Foundation
import SwiftUI

@Observable
class MovieViewModel {

    var currentIndex : Int = 0
    
    /*
     
     배열 선언하는 방법
     -> 빈 정수 배열 만들기
     var numbers : [Int] = []
     -> 초기값이 잇는 배열 만들기 (타입 추론)
     var names = ["Alice", "Bob", "Charlie"]
     
     */
    
    /* movieModel들이 담긴 배열  & Model들을 가지고 오기*/
    let movieModel: [MovieModel] = [
        .init(movieImage: .init(.kingsWarden), movieName: "왕과 사는 남자", movieLike: 972, movieReserCount: 30.8),
        .init(movieImage: .init(.hoppers), movieName: "호퍼스", movieLike: 999, movieReserCount: 99.8),
        .init(movieImage: .init(.theBride), movieName: "브라이드!", movieLike: 302, movieReserCount: 24.8),
        .init(movieImage: .init(.humint), movieName: "휴민트", movieLike: 302, movieReserCount: 3.8),
        .init(movieImage: .init(.madDance), movieName: "매드 댄스 오피스", movieLike: 604, movieReserCount: 62.2),
        
        
        .init(movieImage: .init(.onceWe), movieName: "만약에 우리", movieLike: 392, movieReserCount: 43.9),
        .init(movieImage: .init(.years), movieName: "28년 후: 뼈의 사원", movieLike: 30, movieReserCount: 2.1)
    ]
    
    public func previousMovie() {
        currentIndex = (currentIndex - 1 + movieModel.count) % movieModel.count
    }
    
    public func nextMovie() {
        currentIndex = (currentIndex + 1) % movieModel.count
    }
}
