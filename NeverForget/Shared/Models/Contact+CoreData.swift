//
//  Contact+CoreDataClass.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 12.09.2023.
//
//

import CoreData

// MARK: - Class
@objc(Contact)
public class Contact: NSManagedObject, Identifiable {

  // MARK: - Public Properties
  @NSManaged public var id: ContactId
  @NSManaged public var firstName: String
  @NSManaged public var events: Set<Event>
//  @NSManaged var groups: Set<Group>

  @NSManaged public var lastName: String?
  @NSManaged public var middleName: String?
  @NSManaged public var photoData: Data?

  // MARK: - Overrides
  override public func awakeFromInsert() {
    super.awakeFromInsert()

    id = UUID().uuidString
    firstName = ""
    events = []
  }

  // MARK: - Public methods
  static func fetchById(_ id: String, context: NSManagedObjectContext) throws -> Contact? {
    let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

    let fetchedPersons = try context.fetch(fetchRequest)
    return fetchedPersons.first
  }

  func addAndLinkEvent(_ event: Event) {
    event.contactsIds.insert(self.id)
    events.insert(event)
  }

}

// MARK: - Static
extension Contact {

  // MARK: - Types
  public typealias ContactId = String

  // MARK: - Static Methods
  public static func fetchRequest() -> NSFetchRequest<Contact> {
    return NSFetchRequest<Contact>(entityName: "Contact")
  }

}
