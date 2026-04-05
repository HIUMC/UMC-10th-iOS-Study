//
//  FontManger.swift
//  UMC_MegaBox
//
//  Created by 최민혁 on 3/18/26.
//
import Foundation
import SwiftUI

    
extension Font {
    enum Pretend {
        case extraBold
        case bold
        case semibold
        case regular
        case medium
        case light
        
        var value: String {
            switch self {
            case .extraBold:
                return "Pretendard-ExtraBold"
            case .bold:
                return "Pretendard-Bold"
            case .semibold:
                return "Pretendard-SemiBold"
            case .regular:
                return "Pretendard-Regular"
            case .medium:
                return "Pretendard-Medium"
            case .light:
                return "Pretendard-Light"

            }
        }
    }
    
    static func pretend(type: Pretend, size: CGFloat) -> Font {
        return .custom(type.value, size: size)
    }
    
    // MARK: - ExtraBold
    static var pretendardExtraBold24: Font {
        return .pretend(type: .extraBold, size: 24)
    }
    
    // MARK: - Bold
    static var pretendardBold28: Font {
        return .pretend(type: .bold, size: 28)
    }

    static var pretendardBold24: Font {
        return .pretend(type: .bold, size: 24)
    }
    
    static var pretendardBold22: Font {
        return .pretend(type: .bold, size: 22)
    }
    
    static var pretendardBold18: Font {
        return .pretend(type: .bold, size: 18)
    }
    
    // MARK: - SemiBold
    static var pretendardSemiBold38: Font {
        return .pretend(type: .semibold, size: 38)
    }
    
    static var pretendardSemiBold24: Font {
        return .pretend(type: .semibold, size: 24)
    }
    
    static var pretendardSemiBold18: Font {
        return .pretend(type: .semibold, size: 18)
    }
    
    static var pretendardSemiBold16: Font {
        return .pretend(type: .semibold, size: 16)
    }
    
    static var pretendardSemiBold14: Font {
        return .pretend(type: .semibold, size: 14)
    }
    
    static var pretendardSemiBold13: Font {
        return .pretend(type: .semibold, size: 13)
    }
    
    static var pretendardSemiBold12: Font {
        return .pretend(type: .semibold, size: 12)
    }
    
    // MARK: - Regular
    static var pretendardRegular20: Font {
        return .pretend(type: .regular, size: 20)
    }
    
    static var pretendardRegular18: Font {
        return .pretend(type: .regular, size: 18)
    }
    
    static var pretendardRegular13: Font {
        return .pretend(type: .regular, size: 13)
    }
    
    static var pretendardRegular12: Font {
        return .pretend(type: .regular, size: 12)
    }
    
    static var pretendardRegular9: Font {
        return .pretend(type: .regular, size: 9)
    }
    
    // MARK: - Medium
    static var pretendardMedium18: Font {
        return .pretend(type: .medium, size: 18)
    }
    
    static var pretendardMedium16: Font {
        return .pretend(type: .medium, size: 16)
    }
    
    static var pretendardMedium14: Font {
        return .pretend(type: .medium, size: 14)
    }
    
    static var pretendardMedium13: Font {
        return .pretend(type: .medium, size: 13)
    }
    
    static var pretendardMedium10: Font {
        return .pretend(type: .medium, size: 10)
    }
    
    static var pretendardMedium8: Font {
        return .pretend(type: .medium, size: 8)
    }
    
    // MARK: - Light
    static var pretendardLight14: Font {
        return .pretend(type: .light, size: 14)
    }
}
