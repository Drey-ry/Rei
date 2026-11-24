# Campus Companion iOS - Laboratory Exercise 6

This standalone storyboard-based UIKit project implements the full exercise:

- Part 1: persistent profile photo using `PHPickerViewController`, `NSItemProvider`, `jpegData`, and the Documents directory.
- Part 2: Campus Events detail map using `CLLocationManager`, `MKMapView`, a campus annotation, and a distance label.
- Part 3: Remove Photo and a second labeled campus-library annotation.
- UserDefaults-backed student name, notification preference, and role selection.

## Open and run

1. Open `CampusCompanion_Exercise6.xcodeproj` in Xcode 15 or newer.
2. Select an iPhone Simulator and run the `CampusCompanion_Exercise6` scheme.
3. On the profile screen, tap **Change Photo** and choose an image.
4. Stop and relaunch the app to confirm the image returns from disk.
5. Tap **Campus Announcements**, open an announcement, and grant location access.
6. In the Simulator menu, choose **Features > Location** and select a simulated location.

## Core files

- `ViewController.swift` - Student Profile, photo picker, disk persistence, and Remove Photo.
- `AnnouncementsViewController.swift` - sample campus announcements and navigation to detail.
- `DetailViewController.swift` - map region, two campus landmarks, authorization handling, and distance calculation.
- `Main.storyboard` - Student Profile, Campus Announcements, and Campus Events scenes.
- `Info.plist` - honest When In Use location usage description.

The storyboard contains the navigation scenes, while the screen controls are laid out in Swift. This keeps each laboratory requirement easy to locate and avoids an Xcode 27.1 Interface Builder crash caused by hand-authored Auto Layout scene data.

