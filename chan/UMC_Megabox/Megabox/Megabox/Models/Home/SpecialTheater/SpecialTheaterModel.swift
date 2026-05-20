import Foundation


struct SpecialTheater : Identifiable, Hashable {
    let id = UUID()
    let name : String
    let logoImage : String // 원 안에 들어갈 로고
    let mainImage : String // 특별관 사진
    let description : String // 설명
}
