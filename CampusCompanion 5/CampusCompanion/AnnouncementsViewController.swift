import UIKit
import CoreData

private enum RemoteEndpoint {
    static let announcements = URL(string: "https://raw.githubusercontent.com/feu-mad2/" +
        "campus-companion-api/main/announcements.json")!
}

final class AnnouncementsViewController: UITableViewController {
    private var announcements: [CampusAnnouncement] = []
    private var selectedAnnouncement: CampusAnnouncement?

    private var context: NSManagedObjectContext {
        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Campus Announcements"
        tableView.rowHeight = 88
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(refreshTapped(_:))
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addAnnouncementTapped(_:))
        )
        seedInitialAnnouncementsIfNeeded()
        loadAnnouncements()
    }

    private func seedInitialAnnouncementsIfNeeded() {
        let request: NSFetchRequest<CampusAnnouncement> = CampusAnnouncement.fetchRequest()
        let existingCount = (try? context.count(for: request)) ?? 0
        guard existingCount == 0 else { return }

        let seedData = [
            ("Enrollment Period Extended", "August 3, 2026", "Registrar", "Registrar Office", "Urgent"),
            ("New Library Study Hours", "August 5, 2026", "Library", "Main Library", "Normal"),
            ("Campus Wi-Fi Maintenance", "August 8, 2026", "Technology", "All Campuses", "Urgent"),
            ("Student Organization Fair", "August 12, 2026", "Student Life", "Activity Center", "Normal"),
            ("Scholarship Application Reminder", "August 15, 2026", "Financial Aid", "Student Services", "Urgent"),
            ("Intramural Sports Registration", "August 18, 2026", "Athletics", "Sports Complex", "Normal")
        ]

        for item in seedData {
            let announcement = NSEntityDescription.insertNewObject(
                forEntityName: "CampusAnnouncement",
                into: context
            ) as! CampusAnnouncement
            announcement.title = item.0
            announcement.date = item.1
            announcement.category = item.2
            announcement.location = item.3
            announcement.priority = item.4
        }
        try? context.save()
    }

    private func loadAnnouncements() {
        let request: NSFetchRequest<CampusAnnouncement> = CampusAnnouncement.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        announcements = (try? context.fetch(request)) ?? []
        tableView.reloadData()
    }

    func fetchAnnouncementsFromServer() {
        let task = URLSession.shared.dataTask(with: RemoteEndpoint.announcements) { [weak self] data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Unexpected server response.")
                return
            }

            guard let data = data else { return }
            print(String(data: data, encoding: .utf8) ?? "")
            print("Reached network handler with \(data.count) bytes.")

            do {
                let decodedAnnouncements = try JSONDecoder().decode([AnnouncementDTO].self, from: data)
                print("Decoded \(decodedAnnouncements.count) announcements.")
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.replaceAnnouncements(with: decodedAnnouncements)
                    self.showNetworkConfirmationAlert(byteCount: data.count)
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }
        task.resume()
    }

    private func replaceAnnouncements(with dtos: [AnnouncementDTO]) {
        let request: NSFetchRequest<CampusAnnouncement> = CampusAnnouncement.fetchRequest()
        let existing = (try? context.fetch(request)) ?? []
        existing.forEach { context.delete($0) }

        for dto in dtos {
            let announcement = NSEntityDescription.insertNewObject(
                forEntityName: "CampusAnnouncement",
                into: context
            ) as! CampusAnnouncement
            announcement.title = dto.title
            announcement.date = dto.date
            announcement.category = dto.category
            announcement.location = dto.location
            announcement.priority = dto.priority
        }

        try? context.save()
        loadAnnouncements()
        tableView.reloadData()
    }

    private func showNetworkConfirmationAlert(byteCount: Int) {
        let alert = UIAlertController(
            title: "Server Reached",
            message: "Received \(byteCount) bytes from the announcements endpoint.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @IBAction private func refreshTapped(_ sender: UIBarButtonItem) {
        fetchAnnouncementsFromServer()
    }

    @IBAction private func addAnnouncementTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(
            title: "New Announcement",
            message: "Enter a title and category.",
            preferredStyle: .alert
        )
        alert.addTextField { $0.placeholder = "Title" }
        alert.addTextField { $0.placeholder = "Category" }

        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self, weak alert] _ in
            guard let self,
                  let titleText = alert?.textFields?[0].text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !titleText.isEmpty,
                  let categoryText = alert?.textFields?[1].text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !categoryText.isEmpty else { return }

            let newAnnouncement = NSEntityDescription.insertNewObject(
                forEntityName: "CampusAnnouncement",
                into: self.context
            ) as! CampusAnnouncement
            newAnnouncement.title = titleText
            newAnnouncement.date = DateFormatter.localizedString(from: Date(), dateStyle: .long, timeStyle: .none)
            newAnnouncement.category = categoryText
            newAnnouncement.location = "To be announced"
            newAnnouncement.priority = "Normal"
            try? self.context.save()
            self.loadAnnouncements()
        }
        alert.addAction(saveAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        announcements.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AnnouncementCell", for: indexPath) as? AnnouncementCell else {
            return UITableViewCell()
        }

        cell.configure(with: announcements[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedAnnouncement = announcements[indexPath.row]
        performSegue(withIdentifier: "ShowAnnouncementDetailSegue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowAnnouncementDetailSegue",
              let destination = segue.destination as? DetailViewController,
              let announcement = selectedAnnouncement else {
            return
        }

        destination.announcement = announcement
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let announcement = announcements[indexPath.row]
        context.delete(announcement)
        try? context.save()
        announcements.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
