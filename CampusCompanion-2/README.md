# Campus Companion - MAD2 Laboratory Exercise 2

This is a complete Storyboard/UIKit implementation of the Navigation Controller and User Input exercise.

## Run the project

1. Open `CampusCompanion.xcodeproj` in Xcode on a Mac.
2. Select an iPhone Simulator such as **iPhone 15**, **iPhone 17**, or **iPhone SE**.
3. Choose **Product > Clean Build Folder** once, then press **Command + R**.
4. Enter a name, choose the notification preference and campus role, select an event date, adjust guests, and tap **Explore Campus**.
5. Confirm the detail screen displays all values and that the automatic Back button works.

## Implemented requirements

- Navigation Controller with Campus Companion root title
- Manual Show segue named `ShowDetailSegue`
- `Explore Campus` button and `exploreButtonTapped(_:)` IBAction
- `UITextField` for the student's name
- `UISwitch` for event notifications
- `UISegmentedControl` for Student or Faculty
- `UIDatePicker` for preferred event date
- `UIStepper` for number of guests
- `prepare(for:sender:)` with guarded destination casting and safe text defaults
- Detail screen summary showing name, role, notifications, date, and guests
- Auto Layout constraints for all interface elements

## Expected default behavior

If the name is left empty, the detail screen uses **Student**. Notifications default to **off**, role defaults to **Student**, and guests default to **1**.
