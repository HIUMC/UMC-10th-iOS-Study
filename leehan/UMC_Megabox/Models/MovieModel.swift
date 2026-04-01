//
//  MovieModel.swift
//  leehan
//
//  Created by 이한결 on 3/31/26.
//

import Foundation

struct MovieModel: Identifiable, Hashable {
    let id: UUID = UUID()
    var moviePoster: String
    var movieName: String
    var movieViews: Int
    
    var movieImage: String = ""
    var movieEngName: String = ""
    var movieDescription: String = ""
    var age: String = ""
    var opening: String = ""
    var time: String = ""
    var genre: String = ""
    var type: String = ""
    var director: String = ""
    var actors: String = ""
}
