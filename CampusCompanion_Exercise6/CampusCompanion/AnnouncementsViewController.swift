import UIKit

struct CampusEvent {
    let title: String
    let date: String
    let category: String
}

final class AnnouncementsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    private let events = [
        CampusEvent(title: "Mobile App Development Workshop", date: "August 20, 2026", category: "Academic"),
        CampusEvent(title: "Campus Club Recruitment Fair", date: "August 24, 2026", category: "Student Life"),
        CampusEvent(title: "Technology Research Showcase", date: "September 2, 2026", category: "Technology"),
        CampusEvent(title: "Wellness and Community Day", date: "September 9, 2026", category: "Community")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Campus Announcements"
        view.backgroundColor = .systemBackground

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AnnouncementCell")
        tableView.rowHeight = 76
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        events.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnnouncementCell", for: indexPath)
        let event = events[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = event.title
        content.secondaryText = "\(event.date) • \(event.category)"
        content.image = UIImage(systemName: "calendar.badge.clock")
        content.imageProperties.tintColor = .systemBlue
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detail = storyboard.instantiateViewController(withIdentifier: "detail-controller") as? DetailViewController else { return }

        let event = events[indexPath.row]
        detail.eventTitleText = event.title
        detail.eventDateText = event.date
        detail.eventCategoryText = event.category
        navigationController?.pushViewController(detail, animated: true)
    }
}

