import ProjectDescription

let project = Project(
    name: "UMC_MegaBox",
    targets: [
        .target(
            name: "UMC_MegaBox",
            destinations: .iOS,
            product: .app,
            bundleId: "com.minheuk.UMC-MegaBox",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                    "UIAppFonts": [
                        "Pretendard-Black.otf",
                        "Pretendard-Bold.otf",
                        "Pretendard-ExtraBold.otf",
                        "Pretendard-ExtraLight.otf",
                        "Pretendard-Light.otf",
                        "Pretendard-Medium.otf",
                        "Pretendard-Regular.otf",
                        "Pretendard-SemiBold.otf",
                        "Pretendard-Thin.otf"
                    ],
                    "KAKAO_REST_API_KEY": "$(KAKAO_REST_API_KEY)",
                    "KAKAO_CLIENT_SECRET": "$(KAKAO_CLIENT_SECRET)",
                    "KAKAO_REDIRECT_URI": "$(KAKAO_REDIRECT_URI)",
                    "TMDB_API_KEY": "$(TMDB_API_KEY)"
                ]
            ),
            sources: ["UMC_MegaBox/Sources/**"], // 현재 폴더의 Sources 안의 모든 파일
            resources: ["UMC_MegaBox/Resources/**"], // 현재 폴더의 Resources 안의 모든 파일
            dependencies: [
                .external(name: "Alamofire"),
                .external(name: "Moya"),
                .external(name: "Kingfisher")
            ],
            settings: .settings(
                configurations: [
                    .debug(name: "Debug", xcconfig: "Secret.xcconfig"),
                    .release(name: "Release", xcconfig: "Secret.xcconfig")
                ]
            )
        ),
        .target(
            name: "UMC_MegaBoxTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.minheuk.UMC-MegaBoxTests",
            infoPlist: .default,
            sources: ["UMC_MegaBox/Tests/**"],
            dependencies: [.target(name: "UMC_MegaBox")]
        ),
    ]
)
