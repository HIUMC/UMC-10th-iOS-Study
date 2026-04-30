//
//  MovieModel.swift
//  Week4
//
//  Created by 김민지 on 4/8/26.
//

import Foundation
import SwiftUI

struct MovieModel: Identifiable {
    let id: UUID = .init()
    let movieImage: Image
    let title: String
    let rate: Double
}
