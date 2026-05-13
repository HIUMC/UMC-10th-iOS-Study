import SwiftUI

extension Font {
    enum Pretend {
        case extraBold, bold, semiBold, regular, medium, light
        
        var value: String {
            switch self {
            case .extraBold: return "Pretendard-ExtraBold"
            case .bold:      return "Pretendard-Bold"
            case .semiBold:  return "Pretendard-SemiBold"
            case .regular:   return "Pretendard-Regular"
            case .medium:    return "Pretendard-Medium"
            case .light:     return "Pretendard-Light"
            }
        }
    }
    
    // 포핀스 예제처럼 size에 기본값(예: 17)을 주면 더 편해요!
    static func pretend(_ type: Pretend, size: CGFloat = 17) -> Font {
        return .custom(type.value, size: size)
    }
    
    // 디자인 시스템에서 자주 쓰는 스타일 미리 정의 (이미 잘 만드셨어요!)
    static var megaboxExtraBold24: Font { .pretend(.extraBold, size: 24) }
    static var megaboxBold20: Font      { .pretend(.bold, size: 20) }
    static var megaboxSemiBold18: Font  { .pretend(.semiBold, size: 18) }
    static var megaboxMedium16: Font    { .pretend(.medium, size: 16) }
    static var megaboxRegular14: Font   { .pretend(.regular, size: 14) }
    static var megaboxLight12: Font     { .pretend(.light, size: 12) }
    static var megaBoxMedium10: Font    {.pretend(.medium, size : 10)}
    static var megaBoxMedium18 :Font    {.pretend(.medium, size : 18)}
}


