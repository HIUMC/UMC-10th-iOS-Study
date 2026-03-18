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
    
    static func pretend(type: Pretend, size: CGFloat) -> Font {
        return .custom(type.value, size: size)
    }
    
    
    static var MegaboxExtraBold24: Font { .pretend(type: .extraBold, size: 24) }
    static var MegaboxBold20: Font      { .pretend(type: .bold, size: 20) }
    static var MegaboxSemiBold18: Font  { .pretend(type: .semiBold, size: 18) }
    static var MegaboxMedium16: Font    { .pretend(type: .medium, size: 16) }
    static var MegaboxRegular14: Font   { .pretend(type: .regular, size: 14) }
    static var MegaboxLight12: Font     { .pretend(type: .light, size: 12) }
}
