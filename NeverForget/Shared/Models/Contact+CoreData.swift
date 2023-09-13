//
//  Contact+CoreData.swift
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
  @NSManaged public var id: String
  @NSManaged public var firstName: String

  @NSManaged public var lastName: String?
  @NSManaged public var middleName: String?
  @NSManaged public var photoData: Data?

  @NSManaged public var events: Set<Event>

  // MARK: - Overrides
  override public func awakeFromInsert() {
    super.awakeFromInsert()

    id = UUID().uuidString
    firstName = ""
    events = getInitializedEventsSet()
  }

  override public func prepareForDeletion() {
    super.prepareForDeletion()
    checkEventsForDeletion()
  }

  // MARK: - Public methods
  static func fetchById(_ id: String, context: NSManagedObjectContext) throws -> Contact? {
    let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

    let fetchedPersons = try context.fetch(fetchRequest)
    return fetchedPersons.first
  }

}

// MARK: - Private
extension Contact {

  private func checkEventsForDeletion() {
    events.forEach { event in
      let isContainsSelf = event.contacts.contains(self)
      let isLastContact = event.contacts.count == 1

      if isContainsSelf, isLastContact {
        managedObjectContext?.delete(event)
      }
    }
  }

  private func getInitializedEventsSet() -> Set<Event> {
    guard let context = managedObjectContext else {
      fatalError("Model without context")
    }

    let dateOfBirthEvent = Event(context: context)
    dateOfBirthEvent.type = .systemGenerated

    return [dateOfBirthEvent]
  }

}

// MARK: - Static
public extension Contact {

  // MARK: - Static Methods
  static func fetchRequest() -> NSFetchRequest<Contact> {
    return NSFetchRequest<Contact>(entityName: "Contact")
  }

}
