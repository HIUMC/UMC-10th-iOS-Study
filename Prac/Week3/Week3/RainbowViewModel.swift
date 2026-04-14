//
//  RainbowViewModel.swift
//  Week3
//
//  Created by 김민지 on 4/1/26.
//

import Foundation
import SwiftUI
import Observation

@Observable
class RainbowViewModel {
    // 사용자가 그리드에서 선택한 무지개 모델 (ColorNavigationView에서 사용)
    var selectedRainbowModel: RainbowModel?
    
    // 실제로 사과 로고에 입혀질 색상 (RainbowView의 하단 로고에서 사용)
    var appleLogoColor: Color?
    
    // 초기화 시 기본값을 설정
    init(selectedRainbowModel: RainbowModel? = nil, appleLogoColor: Color? = nil) {
        self.selectedRainbowModel = selectedRainbowModel
        self.appleLogoColor = appleLogoColor
    }
}
