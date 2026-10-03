import UIKit

final class DetailViewController: UIViewController {
    @IBOutlet private weak var messageLabel: UILabel!

    var studentName = "Student"
    var notificationsEnabled = false
    var selectedRole = "Student"
    var preferredEventDate = Date()
    var guestCount = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Campus Events"

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let notificationStatus = notificationsEnabled ? "on" : "off"
        messageLabel.text = "Welcome, \(studentName)! (\(selectedRole))\nNotifications: \(notificationStatus)\nEvent date: \(formatter.string(from: preferredEventDate))\nGuests: \(guestCount)"
    }
}
