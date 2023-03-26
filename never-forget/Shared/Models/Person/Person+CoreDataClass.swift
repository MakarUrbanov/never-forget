//
//  Person+CoreDataClass.swift
//  never-forget
//
//  Created by makar on 2/19/23.
//
//

import CoreData
import Foundation

@objc(Person)
public class Person: NSManagedObject, Identifiable {

  @NSManaged var dateOfBirth: Date?
  @NSManaged var name: String?
  @NSManaged var personDescription: String?
  @NSManaged var photo: Data?
  @NSManaged var events: NSSet?

}
