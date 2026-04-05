import ProjectDescription

let project = Project(
    name: "iOS_Workbook_3rd",
    targets: [
        .target(
            name: "iOS_Workbook_3rd",
            destinations: .iOS,
            product: .app,
            bundleId: "dev.tuist.iOS-Workbook-3rd",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            buildableFolders: [
                "iOS_Workbook_3rd/Sources",
                "iOS_Workbook_3rd/Resources",
            ],
            dependencies: []
        ),
        .target(
            name: "iOS_Workbook_3rdTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "dev.tuist.iOS-Workbook-3rdTests",
            infoPlist: .default,
            buildableFolders: [
                "iOS_Workbook_3rd/Tests"
            ],
            dependencies: [.target(name: "iOS_Workbook_3rd")]
        ),
    ]
)
