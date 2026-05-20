import ProjectDescription

let project = Project(
    name: "Week3_Practice",
    targets: [
        .target(
            name: "Week3_Practice",
            destinations: .iOS,
            product: .app,
            bundleId: "dev.tuist.Week3-Practice",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            buildableFolders: [
                "Week3_Practice/Sources",
                "Week3_Practice/Resources",
            ],
            dependencies: []
        ),
        .target(
            name: "Week3_PracticeTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "dev.tuist.Week3-PracticeTests",
            infoPlist: .default,
            buildableFolders: [
                "Week3_Practice/Tests"
            ],
            dependencies: [.target(name: "Week3_Practice")]
        ),
    ]
)
