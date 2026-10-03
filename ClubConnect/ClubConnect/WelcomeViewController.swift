import UIKit

final class WelcomeViewController: UIViewController {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var reminderSwitch: UISwitch!
    @IBOutlet private weak var roleSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var clubImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // The title is assigned in code to demonstrate an IBOutlet connection.
        titleLabel.text = "Campus Club Connect"
        nameTextField.placeholder = "Enter your name"
        nameTextField.autocorrectionType = .no

        clubImageView.image = UIImage(systemName: "person.3.fill")
        clubImageView.tintColor = .systemBlue
        clubImageView.accessibilityLabel = "Campus club logo placeholder"

        title = "Campus Club Connect"
    }

    @IBAction private func joinClubTapped(_ sender: UIButton) {
        // Dismiss the keyboard before the navigation animation begins.
        nameTextField.resignFirstResponder()
        performSegue(withIdentifier: "ShowConfirmationSegue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowConfirmationSegue",
              let destination = segue.destination as? ConfirmationViewController else {
            return
        }

        let enteredName = nameTextField.text ?? ""
        destination.studentName = enteredName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            ? "Club Member"
            : enteredName
        destination.wantsMeetingReminders = reminderSwitch.isOn
        destination.selectedRole = roleSegmentedControl.selectedSegmentIndex == 0 ? "Member" : "Officer"
    }
}
