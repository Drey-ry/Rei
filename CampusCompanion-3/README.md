# Campus Companion - MAD2 Laboratory Exercise 3

This project extends Exercise 2 with a scrollable announcements list, custom reusable table-view cells, row-to-detail navigation, and the Priority/Posted By coding challenge.

## Run the project

1. Open `CampusCompanion.xcodeproj` in Xcode on a Mac.
2. Select an iPhone Simulator such as **iPhone 15**, **iPhone 17**, or **iPhone SE**.
3. Choose **Product > Clean Build Folder** once, then press **Command + R**.
4. Use **Explore Campus** to verify the original personalized flow.
5. Use **Campus Announcements** to open the six-row list.
6. Confirm urgent rows use a red warning icon, normal rows use a blue megaphone icon, and tapping a row opens its detail screen.

## Implemented requirements

- `CampusAnnouncement` model with title, date, category, priority, and posted office
- Six hardcoded sample announcements
- `UITableViewController` data source and cell reuse identifier `AnnouncementCell`
- Custom `AnnouncementCell` with icon, title, and category/date labels
- Urgent versus Normal visual distinction
- Row selection with `ShowAnnouncementDetailSegue`
- Detail screen that displays title, category, date, priority, and posted-by office
- Existing Exercise 2 welcome/data-passing flow preserved
- Safe guards for segue identifiers, destination types, and optional selected announcements
