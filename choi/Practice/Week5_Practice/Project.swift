import ProjectDescription

let project = Project(
    name: "Week5_Practice",
    targets: [
        .target(
            name: "Week5_Practice",
            destinations: .iOS,
            product: .app,
            bundleId: "dev.tuist.Week5-Practice",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            buildableFolders: [
                "Week5_Practice/Sources",
                "Week5_Practice/Resources",
            ],
            dependencies: []
        ),
        .target(
            name: "Week5_PracticeTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "dev.tuist.Week5-PracticeTests",
            infoPlist: .default,
            buildableFolders: [
                "Week5_Practice/Tests"
            ],
            dependencies: [.target(name: "Week5_Practice")]
        ),
    ]
)
