import UIKit

final class ConfirmationViewController: UIViewController {
    @IBOutlet private weak var messageLabel: UILabel!

    // Defaults keep the screen safe even if it is opened without the expected segue.
    var studentName = "Club Member"
    var wantsMeetingReminders = false
    var selectedRole = "Member"

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Confirmation"
        let reminderStatus = wantsMeetingReminders ? "on" : "off"
        messageLabel.text = "Welcome, \(studentName)!\n\nRole: \(selectedRole)\nMeeting reminders: \(reminderStatus)."
    }
}
