import Foundation

// Identifiable을 채택해야 ForEach에서 id: \.id 없이 깔끔하게 돕니다.
struct MovieModel: Identifiable {
    let id = UUID()              // [ ] Identifier 적용 & UUID 지정 완료
    let title : String
    let posterImage: String      // 포스터 이미지 이름
    let totalAudience: String    // 누적 관객수 (피그마 데이터용)
}
