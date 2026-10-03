import UIKit

final class ViewController: UIViewController {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var campusImageView: UIImageView!
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var notifySwitch: UISwitch!
    @IBOutlet private weak var roleSegmentedControl: UISegmentedControl!
    @IBOutlet private weak var eventDatePicker: UIDatePicker!
    @IBOutlet private weak var guestsStepper: UIStepper!

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = "Campus Companion"
        subtitleLabel.text = "Your Campus, In Your Pocket"
        campusImageView.image = UIImage(systemName: "building.2.crop.circle.fill")
        campusImageView.tintColor = .systemBlue
        campusImageView.accessibilityLabel = "Campus buildings"
        nameTextField.placeholder = "Enter your name"
        nameTextField.autocorrectionType = .no
        eventDatePicker.minimumDate = Date()
        guestsStepper.minimumValue = 1
        guestsStepper.maximumValue = 20
        guestsStepper.stepValue = 1
        guestsStepper.value = 1
    }

    @IBAction private func exploreButtonTapped(_ sender: UIButton) {
        nameTextField.resignFirstResponder()
        performSegue(withIdentifier: "ShowDetailSegue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowDetailSegue",
              let destination = segue.destination as? DetailViewController else {
            return
        }

        let enteredName = nameTextField.text ?? ""
        destination.studentName = enteredName.isEmpty ? "Student" : enteredName
        destination.notificationsEnabled = notifySwitch.isOn
        destination.selectedRole = roleSegmentedControl.selectedSegmentIndex == 0 ? "Student" : "Faculty"
        destination.preferredEventDate = eventDatePicker.date
        destination.guestCount = max(Int(guestsStepper.value), 1)
    }
}
