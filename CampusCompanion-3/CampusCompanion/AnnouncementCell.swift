import UIKit

final class AnnouncementCell: UITableViewCell {
    @IBOutlet private weak var categoryIconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!

    func configure(with announcement: CampusAnnouncement) {
        titleLabel.text = announcement.title
        titleLabel.font = .boldSystemFont(ofSize: 16)
        dateLabel.text = "\(announcement.category) • \(announcement.date)"
        dateLabel.font = .systemFont(ofSize: 13)

        if announcement.priority == "Urgent" {
            categoryIconImageView.image = UIImage(systemName: "exclamationmark.triangle.fill")
            categoryIconImageView.tintColor = .systemRed
        } else {
            categoryIconImageView.image = UIImage(systemName: "megaphone.fill")
            categoryIconImageView.tintColor = .systemBlue
        }
    }
}
