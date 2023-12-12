//
//  Person.swift
//  never-forget
//
//  Created by makar on 2/19/23.
//
//

import CoreData
import Foundation
import UIKit

@objc(Person) public class Person: NSManagedObject, Identifiable {

  @NSManaged public var id: String
  @NSManaged var dateOfBirth: Date
  @NSManaged var name: String
  @NSManaged var personDescription: String
  @NSManaged var photo: Data?
  @NSManaged var isNotificationsEnabled: Bool

  override public func awakeFromInsert() {
    super.awakeFromInsert()
    id = UUID().uuidString
    dateOfBirth = Date.now
    name = ""
    personDescription = ""
  }

}

extension Person {

  private static func fetchRequest() -> NSFetchRequest<Person> {
    NSFetchRequest<Person>(entityName: "Person")
  }

  static func sortedFetchRequest() -> NSFetchRequest<Person> {
    let request: NSFetchRequest<Person> = fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(keyPath: \Person.dateOfBirth, ascending: true)]

    return request
  }

  static func fetchPerson(withId id: String, context: NSManagedObjectContext) throws -> Person? {
    let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

    let fetchedPersons = try context.fetch(fetchRequest)
    return fetchedPersons.first
  }

}
