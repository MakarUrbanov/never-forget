//
//  Person+CoreDataClass.swift
//  never-forget
//
//  Created by makar on 2/19/23.
//
//

import CoreData
import Foundation

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
