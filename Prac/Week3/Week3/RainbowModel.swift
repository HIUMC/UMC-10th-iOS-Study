//
//  RainbowModel.swift
//  Week3
//
//  Created by 김민지 on 4/1/26.
//

import Foundation
import SwiftUI

enum RainbowModel: CaseIterable {
    case red
    case orange
    case yellow
    case green
    case blue
    case purple
    case pink
    
    /// case에 해당하는 색을 반환합니다.
    /// - Returns: 지정된 색 반환
    func returnColor() -> Color {
        switch self {
        case .red:
            return Color.rbRed
        case .orange:
            return Color.rbOrange
        case .yellow:
            return Color.rbYellow
        case .green:
            return Color.rbGreen
        case .blue:
            return Color.rbBlue
        case .purple:
            return Color.rbPurple
        case .pink:
            return Color.rbPink
        }
    }
    
    func returnColorName() -> String {
        switch self {
        case .red:
            return "빨강"
        case .orange:
            return "주황"
        case .yellow:
            return "노랑"
        case .green:
            return "초록"
        case .blue:
            return "파랑"
        case .purple:
            return "보라"
        case .pink:
            return "분홍"
        }
    }
}
