import Foundation

struct TheaterModel: Identifiable, Hashable {
    let id = UUID()
    let logo: String
    let card: String
    let name: String
    let title: String
    let description: String
}
