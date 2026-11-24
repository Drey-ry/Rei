import CoreData

extension Club {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Club> {
        NSFetchRequest<Club>(entityName: "Club")
    }

    @NSManaged public var name: String
    @NSManaged public var category: String
    @NSManaged public var iconName: String
}
