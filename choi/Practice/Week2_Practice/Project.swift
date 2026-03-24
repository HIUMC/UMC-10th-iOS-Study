import ProjectDescription

let project = Project(
    name: "Week2_Practice",
    targets: [
        .target(
            name: "Week2_Practice",
            destinations: .iOS,
            product: .app,
            bundleId: "dev.tuist.Week2-Practice",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            buildableFolders: [
                "Week2_Practice/Sources",
                "Week2_Practice/Resources",
            ],
            dependencies: []
        ),
        .target(
            name: "Week2_PracticeTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "dev.tuist.Week2-PracticeTests",
            infoPlist: .default,
            buildableFolders: [
                "Week2_Practice/Tests"
            ],
            dependencies: [.target(name: "Week2_Practice")]
        ),
    ]
)
