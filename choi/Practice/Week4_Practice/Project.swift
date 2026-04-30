import ProjectDescription

let project = Project(
    name: "Week4_Practice",
    targets: [
        .target(
            name: "Week4_Practice",
            destinations: .iOS,
            product: .app,
            bundleId: "dev.tuist.Week4-Practice",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            buildableFolders: [
                "Week4_Practice/Sources",
                "Week4_Practice/Resources",
            ],
            dependencies: []
        ),
        .target(
            name: "Week4_PracticeTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "dev.tuist.Week4-PracticeTests",
            infoPlist: .default,
            buildableFolders: [
                "Week4_Practice/Tests"
            ],
            dependencies: [.target(name: "Week4_Practice")]
        ),
    ]
)
