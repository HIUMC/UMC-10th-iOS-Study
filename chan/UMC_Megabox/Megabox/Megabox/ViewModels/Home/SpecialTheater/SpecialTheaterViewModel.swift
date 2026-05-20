import SwiftUI
import Observation // ⭐️ Observable 매크로를 위한 임포트

@Observable
class SpecialTheaterViewModel {
    // ⭐️ @Published 없이도 뷰가 변화를 감지합니다.
    var theaters: [SpecialTheater] = []
    var selectedTheater: SpecialTheater?
    
    init() {
        self.theaters = [
            SpecialTheater(name: "Boutique", logoImage: "Boutique", mainImage: "photo_Boutique", description: "섬세하게 디자인된 감각적인 \n극장 경험"),
            SpecialTheater(name: "Boutique Private", logoImage: "Boutique Private", mainImage: "photo_Boutique Private", description: "오직 나와 소중한 사람들을 위한 \n프라이빗한 극장 경험"),
            SpecialTheater(name: "Boutique Suite", logoImage: "Boutique Suite", mainImage: "photo_Boutique Suite", description: "웰컴 패키지가 더해진\n럭셔리한 공간 경험"),
            SpecialTheater(name: "Comfort", logoImage: "Comfort", mainImage: "photo_Comfort", description: "컴포트 체어로 누리는\n 더 안락한 영화 경험"),
            SpecialTheater(name: "Dolby Atmos", logoImage: "Dolby Atmos", mainImage: "photo_Dolby Atmos", description: "차원이 다른 공간감과 디테일한 사운드"),
            
            SpecialTheater(name: "Dolby Cinema", logoImage: "Dolby Cinema", mainImage: "photo_Dolby Cinema", description: "완벽한 영화 관람을 완성하는 \n하이엔드 시네마"),
            SpecialTheater(name: "Dolby Vision+Atmos", logoImage: "Dolby Vision+Atmos", mainImage: "photo_Dolby Vision+Atmos", description: "돌비 시네마의 선명한 영상과 압도적인 사운드, \n리클라이너를 더한 프리미엄 클래스"),
            SpecialTheater(name: "Le Recliner", logoImage: "Le Recliner", mainImage: "photo_Le Recliner", description: "맞춤형 리클라이닝 시스템이 구현하는\n극강의 편안함"),
            SpecialTheater(name: "LED", logoImage: "LED", mainImage: "photo_LED", description: "무한대의 명암비, 완벽한 컬러 재현력"),
            SpecialTheater(name: "MX4D", logoImage: "MX4D", mainImage: "photo_MX4D", description: "다이내믹 이펙트가 선사하는\n새로운 영화 체험"),
        ]
        self.selectedTheater = theaters.first
    }
}
