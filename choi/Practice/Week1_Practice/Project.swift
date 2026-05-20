import ProjectDescription

let project = Project(
    name: "Week1_Practice",
    targets: [
        .target(
            name: "Week1_Practice",
            destinations: .iOS,
            product: .app,
            bundleId: "com.minheuk.Week1Practice",
            //infoPlist: "Week1-Practice-Info.plist",
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
                    ]
                ]
            ),
            sources: ["Week1_Practice/Sources/**"],        // 소스 코드가 들어있는 폴더 경로
            resources: ["Week1_Practice/Resources/**"],           // 리소스 폴더가 있다면 포함
            dependencies: []
        )
    ]
)




