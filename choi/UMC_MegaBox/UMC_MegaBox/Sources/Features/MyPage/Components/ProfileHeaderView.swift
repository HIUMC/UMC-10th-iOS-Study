//
//  ProfileHeaderView.swift
//  UMC_MegaBox
//
//  Created by 최민혁 on 3/25/26.
//

import SwiftUI
import UIKit

struct ProfileHeaderView: View {
    let name: String
    let profileImage: UIImage?
    let membershipPoints: String
    let onAvatarLongPress: () -> Void
    let onMemberInfoTap: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ProfileAvatarView(
                image: profileImage,
                onLongPress: onAvatarLongPress
            )

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text("\(displayName)님")
                        .font(.pretendardBold24)
                    
                    Text("WELCOME")
                        .font(.pretendardMedium14)
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color(red: 0.28, green: 0.8, blue: 0.82))
                        .cornerRadius(12)
                }
                
                HStack(spacing: 4) {
                    Text("멤버십 포인트")
                        .font(.pretendardSemiBold14)
                        .frame(width: 76, height: 20)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(Color(.gray04))
                    Text(membershipPoints)
                        .font(.pretendardMedium14)
                        .foregroundColor(Color(.black))
                        .multilineTextAlignment(.trailing)
                }
            }
            Spacer(minLength: 8)
            
            // 회원정보 버튼
            Button(action: onMemberInfoTap) {
                Text("회원정보")
                    .font(.pretendardSemiBold14)
                    .foregroundColor(.white)
                    .frame(width: 72, height: 32)
            }
            .memberInfoButtonStyle()
        }
    }

    private var displayName: String {
        name.isEmpty ? "회원" : name
    }
}

private struct ProfileAvatarView: View {
    let image: UIImage?
    let onLongPress: () -> Void

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    Circle()
                        .fill(Color(.gray02).opacity(0.22))
                    Image(systemName: "person.fill")
                        .font(.system(size: 25, weight: .semibold))
                        .foregroundColor(Color(.gray04))
                }
            }
        }
        .frame(width: 54, height: 54)
        .clipShape(Circle())
        .contentShape(Circle())
        .onLongPressGesture(minimumDuration: 1.0, perform: onLongPress)
        .accessibilityLabel("프로필 사진")
        .accessibilityHint("1초 동안 길게 누르면 앨범에서 프로필 사진을 선택합니다")
    }
}

private extension View {
    @ViewBuilder
    func memberInfoButtonStyle() -> some View {
        if #available(iOS 26.0, *) {
            self
                .background(Color(.gray07), in: Capsule())
                .glassEffect(.regular.interactive(), in: Capsule())
        } else {
            self
                .background(Color(.gray07), in: Capsule())
        }
    }
}

#Preview {
    ProfileHeaderView(
        name: "최민혁",
        profileImage: nil,
        membershipPoints: "포인트 값 입력",
        onAvatarLongPress: {},
        onMemberInfoTap: {}
    )
}
