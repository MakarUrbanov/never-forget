//
//  Contact+CoreData.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 12.09.2023.
//
//

import CoreData
import SwiftDate

// MARK: - Class
@objc(Contact)
public class Contact: NSManagedObject, Identifiable {

  // MARK: - Public Properties
  @NSManaged public var id: String
  @NSManaged public var firstName: String
  @NSManaged public private(set) var nearestEventDate: Date?

  @NSManaged public var lastName: String?
  @NSManaged public var middleName: String?
  @NSManaged public var photoData: Data?

  @NSManaged public var events: Set<Event>
  @NSManaged public var ownedEvents: Set<Event>

  // MARK: - Private properties
  private var isUpdatingNearestEventDate = false

  // MARK: - Overrides
  override public func awakeFromInsert() {
    super.awakeFromInsert()

    id = UUID().uuidString
    firstName = ""
    events = []
  }

  override public func willSave() {
    super.willSave()
    startUpdatingNearestEventDate()
  }

  public override func didSave() {
    super.didSave()
    finishUpdatingNearestEventDate()
  }

  override public func prepareForDeletion() {
    super.prepareForDeletion()
  }

  // MARK: - Public methods
  public func createLinkedEvent(of type: Event.EventType = .userCreated) -> Event {
    guard let context = managedObjectContext else {
      fatalError("Model without context")
    }

    let event = Event(context: context)
    event.type = type
    event.owner = self

    events.insert(event)

    return event
  }

  public func generateFullName() -> String {
    return [lastName, firstName, middleName].compactMap { $0 }.joined(separator: " ")
  }

}

// MARK: - Private
extension Contact {

  private func startUpdatingNearestEventDate() {
    if isUpdatingNearestEventDate { return }

    isUpdatingNearestEventDate = true
    updateNearestEventDate()
  }

  private func finishUpdatingNearestEventDate() {
    isUpdatingNearestEventDate = false
  }

  private func updateNearestEventDate() {
    var newNearestEventDate: Date?

    for event in ownedEvents {
      let nextEventDate = event.nextEventDate

      if newNearestEventDate == nil {
        newNearestEventDate = nextEventDate
        continue
      }

      if nextEventDate.isToday {
        newNearestEventDate = nextEventDate
        break
      }

      if let prevNewNearest = newNearestEventDate, prevNewNearest > nextEventDate {
        newNearestEventDate = nextEventDate
      }
    }

    if let newNearestEventDate {
      self.nearestEventDate = newNearestEventDate
    }
  }

}

// MARK: - Static
public extension Contact {

  // MARK: - Static Methods
  static func fetchRequest() -> NSFetchRequest<Contact> {
    return NSFetchRequest<Contact>(entityName: "Contact")
  }

  static func fetchRequestWithSorting(descriptors: [NSSortDescriptor]) -> NSFetchRequest<Contact> {
    let request = fetchRequest()
    request.sortDescriptors = descriptors

    return request
  }

  static func fetchById(_ id: String, context: NSManagedObjectContext) throws -> Contact? {
    let fetchRequest: NSFetchRequest<Contact> = Contact.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

    let fetchedPersons = try context.fetch(fetchRequest)
    return fetchedPersons.first
  }

}
