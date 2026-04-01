//
//  HomeViewModel.swift
//  leehan
//
//  Created by 이한결 on 3/31/26.
//

import Foundation

@Observable
class HomeViewModel {
    let movieDummyList: [MovieModel] = [MovieModel(movieImage: "movie_kingsWarden", movieName: "왕과 사는 남자", movieViews: 1500),
                                        MovieModel(movieImage: "movie_kingsWarden", movieName: "왕과 사는 남자", movieViews: 1500),
                                        MovieModel(movieImage: "movie_kingsWarden", movieName: "왕과 사는 남자", movieViews: 1500),
                                        MovieModel(movieImage: "movie_kingsWarden", movieName: "왕과 사는 남자", movieViews: 1500),
                                        MovieModel(movieImage: "movie_kingsWarden", movieName: "왕과 사는 남자", movieViews: 1500),
                                        MovieModel(movieImage: "movie_kingsWarden", movieName: "왕과 사는 남자", movieViews: 1500),
                                        MovieModel(movieImage: "movie_kingsWarden", movieName: "왕과 사는 남자", movieViews: 1500)]
    
    let specialTheaterDummyList: [SpecialTheater] = [SpecialTheater(specialImage: "special_Dolby_Vision+Atmos"),
                                                     SpecialTheater(specialImage: "special_MX4D"),
                                                     SpecialTheater(specialImage: "special_Dolby_Vision+Atmos"),
                                                     SpecialTheater(specialImage: "special_MX4D"),
                                                     SpecialTheater(specialImage: "special_Dolby_Vision+Atmos"),
                                                     SpecialTheater(specialImage: "special_MX4D"),
                                                     SpecialTheater(specialImage: "special_Dolby_Vision+Atmos"),
                                                     SpecialTheater(specialImage: "special_Dolby_Vision+Atmos"),
                                                     SpecialTheater(specialImage: "special_Dolby_Vision+Atmos")]
}
