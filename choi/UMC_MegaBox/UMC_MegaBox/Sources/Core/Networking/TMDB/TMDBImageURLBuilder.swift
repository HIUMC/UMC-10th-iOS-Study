import Foundation

enum TMDBImageURLBuilder {
    private static let baseURLString = "https://image.tmdb.org/t/p"

    static func posterURL(path: String?) -> URL? {
        imageURL(path: path, size: "w500")
    }

    static func backdropURL(path: String?) -> URL? {
        imageURL(path: path, size: "w780")
    }

    private static func imageURL(path: String?, size: String) -> URL? {
        guard let path,
              path.hasPrefix("/") else {
            return nil
        }

        return URL(string: "\(baseURLString)/\(size)\(path)")
    }
}
