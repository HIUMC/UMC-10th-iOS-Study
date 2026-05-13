//
//  UserInfoView.swift
//  MegaBox
//
//  Created by 김민지 on 4/1/26.
//

import SwiftUI

struct MyPageView: View {
    
    // @AppStorage를 통해 로그인 시 저장한 이름 가져오기
    @AppStorage("savedId") private var userName: String = ""
    
    // 이름 일부 가리기
    private var maskedUserName: String {
        // 이름이 2글자 미만이면 마스킹할 필요 없이 그대로 반환
        if userName.count <= 1 { return userName }
            
        // 이름이 2글자이면 성만 반환
        if userName.count == 2 { return String(userName.first!) }
        
        // 이름이 3글자 이상이면 가운데를 *로 표현해 반환
        let first = userName.prefix(1)
        let last = userName.suffix(1)
        // 중간 글자 수만큼 * 만들기
        let middleCount = userName.count - 2
        let stars = String(repeating: "*", count: max(1, middleCount)) // 최소 1개는 나오도록 설정
            
        return "\(first)\(stars)\(last)"
    }
    
    var body: some View {
        // 조건: 전체 하위 뷰를 VStack으로 조립
        VStack(spacing: 30) {
            profileHeader
            
            membershipButton
            
            statusInfoView
            
            reservationMenu
            
            Spacer()
        }
        .padding()
        .background(Color.white)
    }
    
    // 프로필 헤더
    private var profileHeader: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 7) {
                HStack {
                    Text("\(maskedUserName)님")
                        .pretendStyle(.bold24)
                    
                    Text("WELCOME")
                        .pretendStyle(.medium14)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.saturday)
                        .foregroundColor(.white)
                        .cornerRadius(6)
                }
                
                HStack(spacing: 9) {
                    Text("멤버십 포인트")
                        .pretendStyle(.semiBold14)
                        .foregroundColor(.gray04)
                    Text("포인트 값 입력")
                        .pretendStyle(.medium14)
                }
            }
            
            Spacer()
            
            // 조건: 회원정보 버튼은 꼭 버튼으로 구현
            Button(action: { /* */
            }) {
                Text("회원정보")
                    .pretendStyle(.semiBold14)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color(.gray07))
                    .foregroundColor(.white)
                    .cornerRadius(16)
            }
        }
    }
    
    // 클럽 멤버십 버튼
    private var membershipButton: some View {
        Button(action: {}) {
            HStack {
                Text("클럽 멤버십")
                    .pretendStyle(.semiBold16)
                Image(systemName: "chevron.right")
                    .font(.system(size: 16))
                Spacer()
            }
            .foregroundColor(.white)
            .padding(12)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.grad1,Color.grad2, Color.grad3]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(8)
        }
    }
    
    // 상태정보 뷰 (쿠폰, 스토어, 티켓)
    private var statusInfoView: some View {
        HStack(spacing: 17) {
            statusItem(title: "쿠폰", count: "2")
            Divider().frame(height: 43)
            statusItem(title: "스토어 교환권", count: "0")
            Divider().frame(height: 43)
            statusItem(title: "모바일 티켓", count: "0")
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(.gray02), lineWidth: 1)
        )
    }
    
    // 상태정보 내부 반복되는 아이템 함수
    private func statusItem(title: String, count: String) -> some View {
        VStack(spacing: 9) {
            Text(title)
                .pretendStyle(.semiBold16)
                .foregroundColor(.gray02)
            Text(count)
                .pretendStyle(.semiBold18)
        }
        .frame(maxWidth: .infinity)
    }
    
    // 하단 예매 뷰
    private var reservationMenu: some View {
        // 조건: HStack으로 구성
        HStack {
            menuItem(imageName: "MP1", title: "영화별예매")
            menuItem(imageName: "MP2", title: "극장별예매")
            menuItem(imageName: "MP3", title: "특별관예매")
            menuItem(imageName: "MP4", title: "모바일오더")
        }
    }
    
    // 하단 메뉴 내부 아이템 함수
    private func menuItem(imageName: String, title: String) -> some View {
        VStack(spacing: 10) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28)
            Text(title)
                .pretendStyle(.medium16)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    MyPageView()
}
