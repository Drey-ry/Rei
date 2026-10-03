# Campus Club Connect - MP1

This is an independent Swift + Storyboard/UIKit implementation of the Campus Club Connect machine problem.

## Run

1. Open `ClubConnect.xcodeproj` in Xcode on a Mac.
2. Select an iPhone Simulator, such as iPhone SE (3rd generation) or iPhone 15 Pro Max.
3. Press **Command + R**.
4. Enter a name, choose meeting reminders, select Member or Officer, then tap **Join the Club**.
5. Confirm that the confirmation screen displays the values and that the automatic Back button works.

## Required behavior included

- Independent product named `ClubConnect`
- Storyboard/UIKit interface with Auto Layout
- Navigation Controller and two screens
- Manual Show segue named `ShowConfirmationSegue`
- Title label connected as `titleLabel` and set programmatically
- Name text field, reminder switch, and Member/Officer segmented control
- Defensive `prepare(for:sender:)` implementation using `guard`
- Safe empty-name fallback to `Club Member`
- Keyboard dismissal with `resignFirstResponder()`
- Confirmation screen with personalized message

## Submission checklist

- Submit this complete project folder as a ZIP, including the `.git` history.
- Capture a welcome-screen screenshot with sample values entered.
- Capture a confirmation-screen screenshot showing the resulting message.
- Capture screenshots on two different Simulator device sizes.
- Include `Reflection.md` with the required 3-5 sentence comparison.
