import Foundation
import SwiftUI

// ReservationModel.swift
struct ReservationModel: Identifiable{ // 이름을 바꿔줍니다!
    let id: UUID = .init()
    let movieImage: Image  // 실습 코드 형식에 맞춰 Image 타입을 쓰셔도 됩니다.
    let title: String
    let rate: Double
}

// 극장 종류
enum Theater: String, CaseIterable {
    case gangnam = "강남"
    case hongdae = "홍대"
    case sinchon = "신촌"
}
