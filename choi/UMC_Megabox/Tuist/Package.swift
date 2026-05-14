// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,]
        productTypes: [:]
    )
#endif

let package = Package(
    name: "UMC_MegaBox",
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.12.0"),
        .package(url: "https://github.com/Moya/Moya.git", from: "15.0.3"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "8.0.0"),
        // Kakao SDK is resolved for the week 6 SPM requirement, but Kakao Login
        // below is implemented through the REST API with Alamofire as requested.
        .package(url: "https://github.com/kakao/kakao-ios-sdk.git", from: "2.27.3"),
    ]
)
