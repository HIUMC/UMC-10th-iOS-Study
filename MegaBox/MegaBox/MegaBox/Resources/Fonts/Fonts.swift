//
//  Fonts.swift
//  MegaBox
//
//  Created by 김민지 on 3/25/26.
//

import Foundation
import SwiftUI

extension Font {
    enum Pretend {
        case extraBold
        case bold
        case semibold
        case medium
        case regular
        case light
        case custom(String)
        
        var value: String {
            switch self {
            case .extraBold:
                return "Pretendard-ExtraBold"
            case .bold:
                return "Pretendard-Bold"
            case .semibold:
                return "Pretendard-SemiBold"
            case .medium:
                return "Pretendard-Medium"
            case .regular:
                return "Pretendard-Regular"
            case .light:
                return "Pretendard-Light"
            case .custom(let name):
                return name
            }
        }
    }
    
    static func pretend(type: Pretend, size: CGFloat) -> Font {
        return .custom(type.value, size: size)
    }
}


// 폰트 스타일 정보를 담는 구조체
struct PretendardStyle {
    let type: Font.Pretend
    let size: CGFloat
    let lineSpacing: CGFloat?
    let tracking: CGFloat
}

// 텍스트에 스타일을 적용하는 커스텀 함수
extension View {
    func pretendStyle(_ style: PretendardStyle) -> some View {
        self.font(.pretend(type: style.type, size: style.size))
            .tracking(style.tracking)
            .lineSpacing(style.lineSpacing ?? 0)
    }
}

extension PretendardStyle {
    // Bold 시리즈
    static let bold28 = PretendardStyle(type: .bold, size: 28, lineSpacing: nil, tracking: 0)
    static let bold24 = PretendardStyle(type: .bold, size: 24, lineSpacing: 12, tracking: -0.5)
    static let bold22 = PretendardStyle(type: .bold, size: 22, lineSpacing: 8, tracking: -0.5)
    static let bold16 = PretendardStyle(type: .bold, size: 16, lineSpacing: 8, tracking: 0)
    static let bold18 = PretendardStyle(type: .bold, size: 18, lineSpacing: 8, tracking: 0)

    // SemiBold 시리즈
    static let semiBold38 = PretendardStyle(type: .semibold, size: 38, lineSpacing: nil, tracking: 0)
    static let semiBold24 = PretendardStyle(type: .semibold, size: 24, lineSpacing: 12, tracking: -0.5)
    static let semiBold18 = PretendardStyle(type: .semibold, size: 18, lineSpacing: nil, tracking: -0.9) // 5%는 보통 -0.05 * size
    static let semiBold16 = PretendardStyle(type: .semibold, size: 16, lineSpacing: 6, tracking: 0)
    static let semiBold14 = PretendardStyle(type: .semibold, size: 14, lineSpacing: 6, tracking: -0.3)
    static let semiBold13 = PretendardStyle(type: .semibold, size: 13, lineSpacing: 5, tracking: -0.3)
    static let semiBold12 = PretendardStyle(type: .semibold, size: 12, lineSpacing: 8, tracking: -0.3)

    // Regular 시리즈
    static let regular20 = PretendardStyle(type: .regular, size: 20, lineSpacing: nil, tracking: -1.0)
    static let regular18 = PretendardStyle(type: .regular, size: 18, lineSpacing: nil, tracking: -0.9)
    static let regular13 = PretendardStyle(type: .regular, size: 13, lineSpacing: nil, tracking: -0.65)
    static let regular12 = PretendardStyle(type: .regular, size: 12, lineSpacing: nil, tracking: 0)
    static let regular09 = PretendardStyle(type: .regular, size: 9, lineSpacing: nil, tracking: -0.45)

    // Medium 시리즈
    static let medium18 = PretendardStyle(type: .medium, size: 18, lineSpacing: nil, tracking: -0.9)
    static let medium16 = PretendardStyle(type: .medium, size: 16, lineSpacing: nil, tracking: -0.8)
    static let medium13 = PretendardStyle(type: .medium, size: 13, lineSpacing: nil, tracking: -0.65)
    static let medium14 = PretendardStyle(type: .medium, size: 14, lineSpacing: nil, tracking: -0.65)
    static let medium10 = PretendardStyle(type: .medium, size: 10, lineSpacing: 8, tracking: -0.3)
    static let medium08 = PretendardStyle(type: .medium, size: 8, lineSpacing: nil, tracking: -0.4)

    // Light
    static let light14 = PretendardStyle(type: .light, size: 14, lineSpacing: nil, tracking: 0)
}

