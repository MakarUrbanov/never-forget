//
//  PersonAdapter.swift
//  NeverForgetApp
//
//  Created by makar on 5/21/23.
//

import CoreData

struct PersonAdapter: Hashable, Identifiable {

  var id: String
  var objectId: NSManagedObjectID
  var dateOfBirth: Date
  var name: String
  var personDescription: String
  var photo: Data?
  var isNotificationsEnabled: Bool

  init(
    id: String,
    objectId: NSManagedObjectID,
    dateOfBirth: Date,
    name: String,
    personDescription: String,
    photo: Data?,
    isNotificationsEnabled: Bool
  ) {
    self.id = id
    self.objectId = objectId
    self.dateOfBirth = dateOfBirth
    self.name = name
    self.personDescription = personDescription
    self.photo = photo
    self.isNotificationsEnabled = isNotificationsEnabled
  }

  static func create(_ person: Person) -> PersonAdapter {
    self.init(
      id: person.id,
      objectId: person.objectID,
      dateOfBirth: person.dateOfBirth,
      name: person.name,
      personDescription: person.personDescription,
      photo: person.photo,
      isNotificationsEnabled: person.isNotificationsEnabled
    )
  }

  func save(_ context: NSManagedObjectContext) {
    guard let personObject = try? context.existingObject(with: objectId) as? Person else { return }

    personObject.dateOfBirth = dateOfBirth
    personObject.name = name
    personObject.personDescription = personDescription
    personObject.photo = photo
    personObject.isNotificationsEnabled = isNotificationsEnabled

    context.saveChanges()
  }
}
