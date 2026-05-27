import UIKit
import Testing
@testable import UMC_MegaBox

struct UMCMegaBoxTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }

    @Test func profileImageStoreSavesLoadsAndResizesImage() throws {
        let directory = try temporaryDirectory()
        let store = ProfileImageStore(baseDirectory: directory)
        let image = makeImage(size: CGSize(width: 900, height: 600))

        let url = try store.save(image)
        let loaded = try #require(store.load())

        #expect(FileManager.default.fileExists(atPath: url.path))
        #expect(max(pixelWidth(of: loaded), pixelHeight(of: loaded)) <= 512)
    }

    @Test func profileImageStoreKeepsHighScaleImagesWithinPixelLimit() throws {
        let directory = try temporaryDirectory()
        let store = ProfileImageStore(baseDirectory: directory)
        let image = makeImage(size: CGSize(width: 300, height: 300), scale: 3)

        try store.save(image)
        let loaded = try #require(store.load())

        #expect(max(pixelWidth(of: loaded), pixelHeight(of: loaded)) <= 512)
    }

    @Test func profileImageStoreDeleteRemovesSavedImage() throws {
        let directory = try temporaryDirectory()
        let store = ProfileImageStore(baseDirectory: directory)

        try store.save(makeImage())
        try store.delete()

        #expect(store.load() == nil)
    }

    @Test func profileImageStoreMissingAndCorruptFilesReturnNil() throws {
        let directory = try temporaryDirectory()
        let store = ProfileImageStore(baseDirectory: directory)

        #expect(store.load() == nil)

        try FileManager.default.createDirectory(
            at: store.imageURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        try Data("not image".utf8).write(to: store.imageURL)

        #expect(store.load() == nil)
    }

    private func temporaryDirectory() throws -> URL {
        let directory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        return directory
    }

    private func makeImage(
        size: CGSize = CGSize(width: 120, height: 80),
        scale: CGFloat = 1
    ) -> UIImage {
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = scale
        return UIGraphicsImageRenderer(size: size, format: format).image { context in
            UIColor.systemTeal.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }

    private func pixelWidth(of image: UIImage) -> Int {
        image.cgImage?.width ?? Int(image.size.width * image.scale)
    }

    private func pixelHeight(of image: UIImage) -> Int {
        image.cgImage?.height ?? Int(image.size.height * image.scale)
    }
}
