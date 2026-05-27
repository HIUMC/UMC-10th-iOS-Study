import UIKit

struct ProfileImageStore {
    private let fileManager: FileManager
    private let baseDirectory: URL
    private let folderName = "UMC_MegaBox"
    private let fileName = "profile-avatar.jpg"
    private let maxDimension: CGFloat
    private let compressionQuality: CGFloat

    init(
        fileManager: FileManager = .default,
        baseDirectory: URL? = nil,
        maxDimension: CGFloat = 512,
        compressionQuality: CGFloat = 0.82
    ) {
        self.fileManager = fileManager
        self.baseDirectory = baseDirectory ?? fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        self.maxDimension = maxDimension
        self.compressionQuality = compressionQuality
    }

    var imageURL: URL {
        directoryURL.appendingPathComponent(fileName, isDirectory: false)
    }

    func load() -> UIImage? {
        guard let data = try? Data(contentsOf: imageURL) else { return nil }
        return UIImage(data: data)
    }

    func delete() throws {
        guard fileManager.fileExists(atPath: imageURL.path) else { return }
        try fileManager.removeItem(at: imageURL)
    }

    @discardableResult
    func save(_ image: UIImage) throws -> URL {
        try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        let normalized = image.normalizedForProfileStorage(maxDimension: maxDimension)
        guard let data = normalized.jpegData(compressionQuality: compressionQuality) else {
            throw ProfileImageStoreError.jpegEncodingFailed
        }
        try data.write(to: imageURL, options: .atomic)
        return imageURL
    }

    private var directoryURL: URL {
        baseDirectory.appendingPathComponent(folderName, isDirectory: true)
    }
}

enum ProfileImageStoreError: Error, Equatable {
    case jpegEncodingFailed
}

private extension UIImage {
    func normalizedForProfileStorage(maxDimension: CGFloat) -> UIImage {
        let pixelSize = CGSize(
            width: CGFloat(cgImage?.width ?? Int(size.width * scale)),
            height: CGFloat(cgImage?.height ?? Int(size.height * scale))
        )
        let largestPixelSide = max(pixelSize.width, pixelSize.height)
        guard largestPixelSide > 0 else { return normalizedUpOrientation() }

        let resizeScale = min(1, maxDimension / largestPixelSide)
        let targetPixelSize = CGSize(
            width: pixelSize.width * resizeScale,
            height: pixelSize.height * resizeScale
        )
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1
        format.opaque = true

        return UIGraphicsImageRenderer(size: targetPixelSize, format: format).image { _ in
            normalizedUpOrientation().draw(in: CGRect(origin: .zero, size: targetPixelSize))
        }
    }

    func normalizedUpOrientation() -> UIImage {
        guard imageOrientation != .up else { return self }
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = scale
        format.opaque = false
        return UIGraphicsImageRenderer(size: size, format: format).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
