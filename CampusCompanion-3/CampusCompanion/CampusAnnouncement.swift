import Foundation

struct CampusAnnouncement {
    let title: String
    let date: String
    let category: String
    let priority: String
    let postedBy: String
}

extension CampusAnnouncement {
    static let sampleAnnouncements: [CampusAnnouncement] = [
        CampusAnnouncement(title: "Enrollment Period Extended", date: "August 3, 2026", category: "Registrar", priority: "Urgent", postedBy: "Registrar's Office"),
        CampusAnnouncement(title: "New Library Study Hours", date: "August 5, 2026", category: "Library", priority: "Normal", postedBy: "University Library"),
        CampusAnnouncement(title: "Campus Wi-Fi Maintenance", date: "August 8, 2026", category: "Technology", priority: "Urgent", postedBy: "IT Services"),
        CampusAnnouncement(title: "Student Organization Fair", date: "August 12, 2026", category: "Student Life", priority: "Normal", postedBy: "Student Affairs"),
        CampusAnnouncement(title: "Scholarship Application Reminder", date: "August 15, 2026", category: "Financial Aid", priority: "Urgent", postedBy: "Financial Aid Office"),
        CampusAnnouncement(title: "Intramural Sports Registration", date: "August 18, 2026", category: "Athletics", priority: "Normal", postedBy: "Athletics Department")
    ]
}
