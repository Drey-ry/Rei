import PhotosUI
import UIKit

final class ViewController: UIViewController, PHPickerViewControllerDelegate {
    private let profileImageView = UIImageView()
    private let photoStatusLabel = UILabel()
    private let removePhotoButton = UIButton(type: .system)
    private let nameTextField = UITextField()
    private let notificationsSwitch = UISwitch()
    private let roleSegmentedControl = UISegmentedControl(items: ["Student", "Faculty"])

    private let defaults = UserDefaults.standard
    private let profilePhotoFilename = "profilePhoto.jpg"

    private enum DefaultsKey {
        static let studentName = "studentName"
        static let notificationsEnabled = "notificationsEnabled"
        static let roleIndex = "roleIndex"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Student Profile"
        setupUserInterface()
        restoreProfileSettings()
        loadProfileImageFromDisk()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveProfileSettings()
    }

    private func setupUserInterface() {
        view.backgroundColor = .systemBackground

        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 14
        stack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stack)

        let heading = UILabel()
        heading.text = "Student Profile"
        heading.textAlignment = .center
        heading.font = .boldSystemFont(ofSize: 24)

        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.backgroundColor = .secondarySystemBackground
        profileImageView.tintColor = .systemBlue
        profileImageView.image = UIImage(systemName: "person.crop.circle")
        profileImageView.accessibilityLabel = "Student profile photo"

        let changePhotoButton = makeButton(title: "Change Photo")
        changePhotoButton.addTarget(self, action: #selector(changePhotoTapped), for: .touchUpInside)

        removePhotoButton.setTitle("Remove Photo", for: .normal)
        removePhotoButton.setTitleColor(.systemRed, for: .normal)
        removePhotoButton.addTarget(self, action: #selector(removePhotoTapped), for: .touchUpInside)

        photoStatusLabel.textAlignment = .center
        photoStatusLabel.textColor = .secondaryLabel
        photoStatusLabel.numberOfLines = 0
        photoStatusLabel.font = .systemFont(ofSize: 14)

        nameTextField.placeholder = "Student Name"
        nameTextField.borderStyle = .roundedRect
        nameTextField.autocapitalizationType = .words
        nameTextField.returnKeyType = .done
        nameTextField.addTarget(self, action: #selector(profileValueChanged), for: .editingChanged)

        let notificationsLabel = UILabel()
        notificationsLabel.text = "Notifications"
        notificationsLabel.font = .systemFont(ofSize: 17)
        let notificationsRow = UIStackView(arrangedSubviews: [notificationsLabel, notificationsSwitch])
        notificationsRow.axis = .horizontal
        notificationsRow.alignment = .center
        notificationsRow.spacing = 12
        notificationsLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        notificationsSwitch.addTarget(self, action: #selector(profileValueChanged), for: .valueChanged)

        roleSegmentedControl.selectedSegmentIndex = 0
        roleSegmentedControl.addTarget(self, action: #selector(profileValueChanged), for: .valueChanged)

        let announcementsButton = makeButton(title: "Campus Announcements  ›")
        announcementsButton.addTarget(self, action: #selector(openAnnouncementsTapped), for: .touchUpInside)

        stack.addArrangedSubview(heading)
        stack.addArrangedSubview(profileImageView)
        stack.addArrangedSubview(changePhotoButton)
        stack.addArrangedSubview(removePhotoButton)
        stack.addArrangedSubview(photoStatusLabel)
        stack.addArrangedSubview(nameTextField)
        stack.addArrangedSubview(notificationsRow)
        stack.addArrangedSubview(roleSegmentedControl)
        stack.addArrangedSubview(announcementsButton)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 28),
            stack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -24),
            stack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -28),
            stack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -48),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            announcementsButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    private func makeButton(title: String) -> UIButton {
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.cornerStyle = .medium
        configuration.baseBackgroundColor = .systemBlue
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    @objc private func profileValueChanged() {
        saveProfileSettings()
    }

    private func restoreProfileSettings() {
        nameTextField.text = defaults.string(forKey: DefaultsKey.studentName)
        notificationsSwitch.isOn = defaults.object(forKey: DefaultsKey.notificationsEnabled) as? Bool ?? true

        let savedRoleIndex = defaults.object(forKey: DefaultsKey.roleIndex) as? Int ?? 0
        if savedRoleIndex < roleSegmentedControl.numberOfSegments {
            roleSegmentedControl.selectedSegmentIndex = savedRoleIndex
        }
    }

    private func saveProfileSettings() {
        defaults.set(nameTextField.text ?? "", forKey: DefaultsKey.studentName)
        defaults.set(notificationsSwitch.isOn, forKey: DefaultsKey.notificationsEnabled)
        defaults.set(roleSegmentedControl.selectedSegmentIndex, forKey: DefaultsKey.roleIndex)
    }

    @objc private func changePhotoTapped() {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        configuration.selectionLimit = 1

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let result = results.first else { return }

        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            guard let self = self, let image = object as? UIImage else {
                if let error = error {
                    print("Could not load selected photo: \(error.localizedDescription)")
                }
                return
            }

            DispatchQueue.main.async {
                self.profileImageView.image = image
                self.saveProfileImageToDisk(image)
            }
        }
    }

    private func saveProfileImageToDisk(_ image: UIImage) {
        guard let data = image.jpegData(compressionQuality: 0.8),
              let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            photoStatusLabel.text = "The selected image could not be prepared."
            return
        }

        let fileURL = documentsURL.appendingPathComponent(profilePhotoFilename)

        do {
            try data.write(to: fileURL, options: .atomic)
            removePhotoButton.isEnabled = true
            photoStatusLabel.text = "Photo saved to the Documents directory."
        } catch {
            photoStatusLabel.text = "Could not save the profile photo."
            print("Could not save profile photo: \(error.localizedDescription)")
        }
    }

    private func loadProfileImageFromDisk() {
        guard let fileURL = profilePhotoURL,
              let image = UIImage(contentsOfFile: fileURL.path) else {
            removePhotoButton.isEnabled = false
            photoStatusLabel.text = "No saved photo yet."
            return
        }

        profileImageView.image = image
        removePhotoButton.isEnabled = true
        photoStatusLabel.text = "Photo restored from the Documents directory."
    }

    @objc private func removePhotoTapped() {
        guard let fileURL = profilePhotoURL else { return }

        do {
            if FileManager.default.fileExists(atPath: fileURL.path) {
                try FileManager.default.removeItem(at: fileURL)
            }
            profileImageView.image = UIImage(systemName: "person.crop.circle")
            removePhotoButton.isEnabled = false
            photoStatusLabel.text = "Profile photo removed."
        } catch {
            photoStatusLabel.text = "Could not remove the profile photo."
            print("Could not remove profile photo: \(error.localizedDescription)")
        }
    }

    @objc private func openAnnouncementsTapped() {
        saveProfileSettings()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let announcements = storyboard.instantiateViewController(withIdentifier: "announcements-controller") as? AnnouncementsViewController else { return }
        navigationController?.pushViewController(announcements, animated: true)
    }

    private var profilePhotoURL: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?
            .appendingPathComponent(profilePhotoFilename)
    }
}

