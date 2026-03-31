//
//  MovieModel.swift
//  leehan
//
//  Created by 이한결 on 3/31/26.
//

import Foundation

struct MovieModel: Identifiable {
    let id: UUID = UUID()
    var movieImage: String
    var movieName: String
    var movieViews: Int
}
