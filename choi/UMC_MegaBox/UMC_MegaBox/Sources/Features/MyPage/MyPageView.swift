//
//  dView.swift
//  UMC_MegaBox
//
//  Created by 최민혁 on 3/25/26.
//

import SwiftUI
import UIKit

struct MyPageView: View {
    @Environment(NavigationRouter<MyPageRoute>.self) private var router
    @Environment(AuthViewModel.self) private var authVM
    @State private var profileImage: UIImage?
    @State private var isProfilePickerPresented = false
    @State private var isProfileSaveErrorPresented = false

    private let profileImageStore = ProfileImageStore()

    var body: some View {
        // @Observable 매크로를 쓰는 클래스의 프로퍼티를 바인딩($) 하기 위해
        // @Bindable 래퍼를 사용
        @Bindable var bindableRouter = router
        
        NavigationStack(path: $bindableRouter.path) {
            VStack(spacing: 0) {
                // 프로필 헤더
                ProfileHeaderView(
                    name: authVM.displayName,
                    profileImage: profileImage,
                    membershipPoints: "포인트 값 입력",
                    onAvatarLongPress: { isProfilePickerPresented = true },
                    onMemberInfoTap: { router.push(.profileManage) }
                )
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                
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
            .onAppear {
                profileImage = profileImageStore.load()
            }
            .sheet(isPresented: $isProfilePickerPresented) {
                ProfileImagePicker { image in
                    storeProfileImage(image)
                }
            }
            .alert("프로필 사진 저장 실패", isPresented: $isProfileSaveErrorPresented) {
                Button("확인", role: .cancel) {}
            } message: {
                Text("선택한 사진을 저장하지 못했습니다. 다시 시도해 주세요.")
            }
            .navigationDestination(for: MyPageRoute.self) { route in
                switch route {
                case .profileManage:
                    ProfileManageView()
                }
            }
        }
    }

    private func storeProfileImage(_ image: UIImage) {
        do {
            try profileImageStore.save(image)
            profileImage = profileImageStore.load() ?? image
        } catch {
            isProfileSaveErrorPresented = true
        }
    }
}

#Preview {
    MyPageView()
        .environment(NavigationRouter<MyPageRoute>())
        .environment(DIContainer())
        .environment(AuthViewModel())
}
