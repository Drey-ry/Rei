import PhotosUI
import UIKit

final class WelcomeViewController: UIViewController, PHPickerViewControllerDelegate {
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var photoStatusLabel: UILabel!

    private let savedPhotoFilename = "profile-photo.jpg"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Welcome"
        configureProfileImage()
        loadSavedPhoto()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
    }

    private func configureProfileImage() {
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.backgroundColor = .secondarySystemBackground
        profileImageView.image = UIImage(systemName: "person.crop.circle.fill")
        profileImageView.tintColor = .systemGreen
        profileImageView.accessibilityLabel = "Profile photo"
    }

    @IBAction private func choosePhotoTapped(_ sender: UIButton) {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        configuration.selectionLimit = 1

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)

        guard let provider = results.first?.itemProvider,
              provider.canLoadObject(ofClass: UIImage.self) else {
            return
        }

        provider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            guard let self = self, let image = object as? UIImage else {
                if let error = error {
                    print("Profile photo loading failed: \(error.localizedDescription)")
                }
                return
            }

            do {
                guard let jpegData = image.jpegData(compressionQuality: 0.85) else {
                    throw NSError(domain: "CampusClubConnect", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not create JPEG data."])
                }
                try jpegData.write(to: self.savedPhotoURL, options: .atomic)

                DispatchQueue.main.async {
                    self.profileImageView.image = image
                    self.photoStatusLabel.text = "Photo saved to the Documents directory."
                }
            } catch {
                DispatchQueue.main.async {
                    self.photoStatusLabel.text = "Photo could not be saved."
                }
                print("Profile photo save failed: \(error.localizedDescription)")
            }
        }
    }

    private func loadSavedPhoto() {
        guard FileManager.default.fileExists(atPath: savedPhotoURL.path),
              let image = UIImage(contentsOfFile: savedPhotoURL.path) else {
            photoStatusLabel.text = "Choose a photo to save it for the next launch."
            return
        }

        profileImageView.image = image
        photoStatusLabel.text = "Loaded from Documents on launch."
    }

    private var savedPhotoURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(savedPhotoFilename)
    }
}

