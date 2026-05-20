//
//  MovieModel.swift
//  Week4_Practice
//
//  Created by 최민혁 on 4/3/26.
//
import Foundation
import SwiftUI

struct MovieModel: Identifiable {
    let id: UUID = .init()
    let movieImage: Image
    let title: String
    let rate: Double
}
