import Foundation

/// The DTO mirrors the keys in the published JSON file exactly.
struct ClubDTO: Codable {
    let name: String
    let category: String
    let iconName: String
}

