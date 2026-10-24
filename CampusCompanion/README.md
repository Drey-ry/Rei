# Campus Companion - MAD2 Laboratory Exercise 4

This project implements Exercise 4 with UserDefaults persistence, Core Data announcements, reset preferences, and swipe-to-delete.

## Run the project

1. Open `CampusCompanion.xcodeproj` in Xcode on a Mac.
2. Select an iPhone Simulator such as **iPhone 15**, **iPhone 17**, or **iPhone SE**.
3. Choose **Product > Clean Build Folder** once, then press **Command + R**.
4. Use **Explore Campus** to verify the original personalized flow.
5. Use **Campus Announcements** to open the six-row list.
6. Confirm urgent rows use a red warning icon, normal rows use a blue megaphone icon, and tapping a row opens its detail screen.

## Implemented requirements

- `CampusAnnouncement` Core Data entity with title, date, and category
- Six announcements seeded once into the persistent store
- `UITableViewController` data source and cell reuse identifier `AnnouncementCell`
- Custom `AnnouncementCell` with icon, title, and category/date labels
- Add alert for creating new announcements
- Swipe-to-delete with Core Data persistence
- Reset Preferences control for UserDefaults
- Row selection with `ShowAnnouncementDetailSegue`
- Detail screen that displays title, category, and date
- Existing Exercise 2 welcome/data-passing flow preserved
- Safe guards for segue identifiers, destination types, and optional selected announcements
