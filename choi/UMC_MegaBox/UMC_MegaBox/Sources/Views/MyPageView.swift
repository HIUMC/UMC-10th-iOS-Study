//
//  dView.swift
//  UMC_MegaBox
//
//  Created by 최민혁 on 3/25/26.
//

import SwiftUI

struct MyPageView: View {
    @Environment(NavigationRouter<MyPageRoute>.self) private var router

    var body: some View {
        // @Observable 매크로를 쓰는 클래스의 프로퍼티를 바인딩($) 하기 위해
        // @Bindable 래퍼를 사용
        @Bindable var bindableRouter = router
        
        NavigationStack(path: $bindableRouter.path) {
            VStack(spacing: 0) {
                // 프로필 헤더
                ProfileHeaderView()
                    .padding(.top, 20)
                    .padding(.horizontal, 25)
                
                // 클럽 멤버십 바
                ClubMembershipButton()
                    .padding(.top, 10)
                    .padding(.horizontal, 20)
                
                // 쿠폰 / 스토어 교환권 / 모바일 티켓
                StatsInfoView()
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                
                // 퀵 액션 버튼 4개
                QuickActionsRow()
                    .padding(.top, 24)
                    .padding(.horizontal, 20)
                Spacer()
            }
            .navigationDestination(for: MyPageRoute.self) { route in
                switch route {
                case .profileManage:
                    ProfileMangaeView()
                }
            }
        }
    }
}

    
struct ClubMembershipButton: View {
    var body: some View {
        Button(action: {}) {
            HStack(alignment: .center, spacing: 3) {
                Text("클럽 멤버십")
                    .font(.pretendardSemiBold16)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.trailing)
                Image(systemName: "chevron.right")
                    .frame(width:16, height:16)
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.leading, 15)
            .padding(.vertical, 15)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: Color(red: 0.67, green: 0.55, blue: 1), location: 0.00),
                        Gradient.Stop(color: Color(red: 0.56, green: 0.68, blue: 0.95), location: 0.53),
                        Gradient.Stop(color: Color(red: 0.36, green: 0.8, blue: 0.93), location: 1.00),
                    ],
                    startPoint: UnitPoint(x: 0, y: 0.5),
                    endPoint: UnitPoint(x: 1, y: 0.5)
                )
            )
            .cornerRadius(8)
            }
    }
}

struct StatsInfoView: View {
    var body: some View {
        HStack(spacing: 0) {
            StatItem(title: "쿠폰", value: "3")
            Divider()
                .frame(height: 40)
            StatItem(title: "스토어 교환권", value: "0")
            Divider()
                .frame(height: 40)
            StatItem(title: "모바일 티켓", value: "1")
        }
        .padding(.vertical, 16)
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(.gray02))
        )
    }
}

struct StatItem: View {
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 9) {
            Text(title)
                .font(.pretendardSemiBold16)
                .foregroundColor(Color(.gray02))
            Text(value)
                .font(.pretendardSemiBold18)
                .foregroundColor(Color(.black))
        }
        .frame(maxWidth: .infinity)
    }
}

struct QuickActionsRow: View {
    var body: some View {
        HStack(spacing: 0) {
            QuickActionButton(imageName: "영화관예매")
            QuickActionButton(imageName: "극장별예매")
            QuickActionButton(imageName: "특별관예매")
            QuickActionButton(imageName: "모바일오더")
        }
    }
}


#Preview {
    MyPageView()
        .environment(NavigationRouter<MyPageRoute>())
        .environment(DIContainer())
        .environment(AuthViewModel())
}
