//
//  SpecialTheater.swift
//  leehan
//
//  Created by 이한결 on 4/1/26.
//

import Foundation

struct SpecialTheater: Identifiable {
    let id: UUID = UUID()
    
    let logoImage: String
    let theaterImage: String
    let title: String
    let description: String
    
    var specialImage: String {
        logoImage
    }
}
