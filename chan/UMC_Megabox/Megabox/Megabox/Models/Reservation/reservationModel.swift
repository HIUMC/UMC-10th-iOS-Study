import Foundation
import SwiftUI

struct ReservationModel: Identifiable, Equatable {
    let id: UUID = .init()
    let posterName: String
    let title: String
    let rate: Double

    var movieImage: Image {
        Image(posterName)
    }

    static func == (lhs: ReservationModel, rhs: ReservationModel) -> Bool {
        lhs.id == rhs.id
    }
}

// 극장 종류
enum Theater: String, CaseIterable {
    case gangnam = "강남"
    case hongdae = "홍대"
    case sinchon = "신촌"
}
