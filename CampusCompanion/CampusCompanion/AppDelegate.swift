import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    lazy var persistentContainer: NSPersistentContainer = {
        let model = NSManagedObjectModel()
        let announcementEntity = NSEntityDescription()
        announcementEntity.name = "CampusAnnouncement"
        announcementEntity.managedObjectClassName = "CampusCompanion.CampusAnnouncement"

        let title = NSAttributeDescription()
        title.name = "title"
        title.attributeType = .stringAttributeType
        title.isOptional = false
        title.defaultValue = ""

        let date = NSAttributeDescription()
        date.name = "date"
        date.attributeType = .stringAttributeType
        date.isOptional = false
        date.defaultValue = ""

        let category = NSAttributeDescription()
        category.name = "category"
        category.attributeType = .stringAttributeType
        category.isOptional = false
        category.defaultValue = ""

        announcementEntity.properties = [title, date, category]
        model.entities = [announcementEntity]

        let container = NSPersistentContainer(name: "CampusCompanion", managedObjectModel: model)
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Unresolved Core Data error: \(error)")
            }
        }
        return container
    }()

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            try? context.save()
        }
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
