//
//  MovieModel 2.swift
//  MegaBox
//
//  Created by 김민지 on 4/7/26.
//


import Foundation

struct MovieModel: Identifiable, Hashable {
    let id = UUID()

    // 홈 화면 (카드)
    let title: String
    let posterImage: String // 💡 변수명 통일
    let audienceCount: Int
    
    // 상세 화면
    let englishTitle: String
    let quote: String
    let description: String
    let rating: String
    let releaseInfo: String
    let genre: String
    let type: String
    let director: String
    let cast: String

    // "누적관객수 n만" 형식으로 포맷팅
    var formattedAudienceCount: String {
        if audienceCount == 0 {
            return "누적관객수 0명" // 0일 때 단위 추가
        }
        return "누적관객수 \(audienceCount)만"
    }
}

// 💡 HomeViewModel에서 에러가 나지 않도록 더미 TheaterModel을 추가해둡니다.
struct TheaterModel: Hashable {
    let logo: String
    let card: String
    let name: String
    let title: String
    let description: String
}
