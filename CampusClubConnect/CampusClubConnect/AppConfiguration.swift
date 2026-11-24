import Foundation

/// Centralized app settings that can be changed without touching networking code.
enum AppConfiguration {
    /// Replace this placeholder with the raw HTTPS URL of your published clubs.json file.
    static let remoteClubsURLString = "https://raw.githubusercontent.com/your-username/campus-clubs/main/clubs.json"

    static let campusName = "Main Campus"
    static let campusCoordinate = CampusCoordinate(latitude: 14.6041, longitude: 120.9891)
}

struct CampusCoordinate {
    let latitude: Double
    let longitude: Double
}

