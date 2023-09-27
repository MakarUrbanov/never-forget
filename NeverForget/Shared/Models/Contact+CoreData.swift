//
//  Contact+CoreData.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 12.09.2023.
//
//

import CoreData
import NFCore
import SwiftDate
import UIKit

// MARK: - Class
@objc(Contact)
public class Contact: NSManagedObject, Identifiable {

  // MARK: - Public Properties
  @NSManaged public var id: String
  @NSManaged public var firstName: String
  @NSManaged public private(set) var nearestEventDate: Date?

  @NSManaged public var lastName: String?
  @NSManaged public var middleName: String?
  @NSManaged public private(set) var photoData: Data?

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

  override public func didSave() {
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

  public func generateInitials() -> String {
    [lastName?.first, firstName.first].compactMap { character in
      if let character {
        return String(character)
      }

      return nil
    }
    .joined(separator: "")
  }

}

// MARK: - Photo
public extension Contact {

  internal static let maxImageSize = CGSize(width: 1_500, height: 1_500)

  func setPhotoAndResize(_ photo: UIImage, completion: @escaping () -> Void) {
    guard let context = managedObjectContext else {
      Logger.error("Can't set photo and resize. Contact has no context")
      return
    }

    context.perform {
      let resizedImage = photo.resized(maxSize: Self.maxImageSize)
      self.photoData = resizedImage.pngData()
      completion()
    }
  }

  func setPhotoData(_ photoData: Data?) {
    self.photoData = photoData
  }

  func clearPhotoData() {
    photoData = nil
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
      nearestEventDate = newNearestEventDate
    }
  }

}

// MARK: - Fetch
public extension Contact {

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
