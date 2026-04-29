//
//  HomeViewModel.swift
//  leehan
//
//  Created by 이한결 on 3/31/26.
//

import Foundation

@Observable
class HomeViewModel {
    let movieDummyList1: [MovieModel] = [MovieModel(moviePoster: "movie_kingsWarden", movieName: "왕과 사는 남자", movieViews: 1500),
                                        MovieModel(moviePoster: "movie_kingsWarden", movieName: "왕과 사는 남자", movieViews: 1500),
                                        MovieModel(moviePoster: "movie_kingsWarden", movieName: "왕과 사는 남자", movieViews: 1500),
                                        MovieModel(moviePoster: "movie_kingsWarden", movieName: "왕과 사는 남자", movieViews: 1500),
                                        MovieModel(moviePoster: "movie_kingsWarden", movieName: "왕과 사는 남자", movieViews: 1500),
                                        MovieModel(moviePoster: "movie_kingsWarden", movieName: "왕과 사는 남자", movieViews: 1500),
                                        MovieModel(moviePoster: "movie_kingsWarden", movieName: "왕과 사는 남자", movieViews: 1500)]
    
    let movieDummyList: [MovieModel] = [MovieModel(
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
    ),
                                         MovieModel(
                                             moviePoster: "movie_humint",
                                             movieName: "휴민트",
                                             movieViews: 1000,
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
                                         ),
                                         MovieModel(
                                             moviePoster: "movie_madDance",
                                             movieName: "매드댄스 오피스",
                                             movieViews: 800,
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
                                         ),
                                         MovieModel(
                                             moviePoster: "movie_method",
                                             movieName: "메소드연기",
                                             movieViews: 1000,
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
                                         ),
                                         MovieModel(
                                             moviePoster: "movie_project",
                                             movieName: "호퍼스",
                                             movieViews: 100,
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
                                         ),
                                         MovieModel(
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
                                         ),
                                         MovieModel(
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
                                         ),
                                         MovieModel(
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
                                         )]
    
    let specialTheaterDummyList: [SpecialTheater] = [
        SpecialTheater(
            logoImage: "special_Dolby_Vision+Atmos",
            theaterImage: "image_theater_Comfort",
            title: "DOLBY CINEMA",
            description: "완벽한 영화 관람을 완성하는 하이엔드 시네마"
        ),
        SpecialTheater(
            logoImage: "special_MX4D",
            theaterImage: "image_theater_MX4D",
            title: "MX4D",
            description: "모션과 바람, 진동으로 장면을 생생하게 체감하는 특별관"
        ),
        SpecialTheater(
            logoImage: "special_Boutique",
            theaterImage: "image_theater_Comfort",
            title: "BOUTIQUE",
            description: "더 넓고 안락한 좌석에서 프리미엄 관람을 즐기는 상영관"
        ),
        SpecialTheater(
            logoImage: "special_Dolby_Vision+Atmos",
            theaterImage: "image_theater_Dolby_atoms",
            title: "DOLBY ATMOS",
            description: "공간을 가득 채우는 입체 음향으로 몰입감을 높이는 상영관"
        ),
        SpecialTheater(
            logoImage: "special_Dolby_Vision+Atmos",
            theaterImage: "image_theater_Comfort",
            title: "DOLBY CINEMA",
            description: "완벽한 영화 관람을 완성하는 하이엔드 시네마"
        ),
        SpecialTheater(
            logoImage: "special_MX4D",
            theaterImage: "image_theater_MX4D",
            title: "MX4D",
            description: "모션과 바람, 진동으로 장면을 생생하게 체감하는 특별관"
        ),
        SpecialTheater(
            logoImage: "special_Boutique",
            theaterImage: "image_theater_Comfort",
            title: "BOUTIQUE",
            description: "더 넓고 안락한 좌석에서 프리미엄 관람을 즐기는 상영관"
        ),
        SpecialTheater(
            logoImage: "special_Dolby_Vision+Atmos",
            theaterImage: "image_theater_Dolby_atoms",
            title: "DOLBY ATMOS",
            description: "공간을 가득 채우는 입체 음향으로 몰입감을 높이는 상영관"
        )
    ]
}
