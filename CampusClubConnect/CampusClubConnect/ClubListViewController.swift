import CoreData
import UIKit

final class ClubListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var refreshButton: UIBarButtonItem!

    private var clubs: [Club] = []
    private let context = PersistenceController.shared.container.viewContext
    private var hasSyncedOnThisAppearance = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Campus Clubs"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ClubCell")
        tableView.rowHeight = 68
        loadLocalClubs()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard !hasSyncedOnThisAppearance else { return }
        hasSyncedOnThisAppearance = true
        syncRemoteClubs()
    }

    @IBAction private func refreshTapped(_ sender: UIBarButtonItem) {
        syncRemoteClubs()
    }

    private func syncRemoteClubs() {
        statusLabel.text = "Syncing from remote JSON..."
        refreshButton?.isEnabled = false

        ClubService.shared.fetchClubs { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.refreshButton?.isEnabled = true

                switch result {
                case .success(let remoteClubs):
                    self.replaceLocalClubs(with: remoteClubs)
                    self.statusLabel.text = "Synced from remote JSON • Core Data refreshed"
                case .failure(let error):
                    print("Remote sync failed: \(error.localizedDescription)")
                    self.loadBundledFallback()
                }
            }
        }
    }

    private func loadBundledFallback() {
        ClubService.shared.loadBundledSample { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let bundledClubs):
                    self.replaceLocalClubs(with: bundledClubs)
                    self.statusLabel.text = "Offline sample loaded • replace the remote URL before submission"
                case .failure(let error):
                    self.statusLabel.text = "No club data available."
                    print("Bundled club fallback failed: \(error.localizedDescription)")
                }
            }
        }
    }

    /// Replaces every stored Club object so Core Data matches the decoded remote array.
    private func replaceLocalClubs(with dtos: [ClubDTO]) {
        let request: NSFetchRequest<Club> = Club.fetchRequest()

        do {
            let existingClubs = try context.fetch(request)
            existingClubs.forEach(context.delete)

            dtos.forEach { dto in
                let club = Club(context: context)
                club.name = dto.name
                club.category = dto.category
                club.iconName = dto.iconName
            }

            try context.save()
            loadLocalClubs()
        } catch {
            statusLabel.text = "Could not save club data."
            print("Core Data club sync failed: \(error.localizedDescription)")
        }
    }

    private func loadLocalClubs() {
        do {
            clubs = try context.fetch(Club.fetchRequest())
                .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
            tableView.reloadData()
        } catch {
            print("Core Data club fetch failed: \(error.localizedDescription)")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        clubs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClubCell", for: indexPath)
        let club = clubs[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = club.name
        content.secondaryText = club.category
        content.image = UIImage(systemName: club.iconName) ?? UIImage(systemName: "person.3.fill")
        content.imageProperties.tintColor = .systemGreen
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

