//
//  RainbowModel.swift
//  Week3_Practice
//
//  Created by 최민혁 on 3/31/26.
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
            return Color.rainbowRed
        case .orange:
            return Color.rainbowOrange
        case .yellow:
            return Color.rainbowYellow
        case .green:
            return Color.rainbowGreen
        case .blue:
            return Color.rainbowBlue
        case .purple:
            return Color.rainbowPurple
        case .pink:
            return Color.rainbowPink
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
