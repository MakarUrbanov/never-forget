//
//  Person+CoreDataProperties.swift
//  never-forget
//
//  Created by makar on 2/19/23.
//
//

import CoreData
import Foundation
import UIKit

extension Person {

  private static func fetchRequest() -> NSFetchRequest<Person> {
    NSFetchRequest<Person>(entityName: "Person")
  }

  static func sortedFetchRequest() -> NSFetchRequest<Person> {
    let request: NSFetchRequest<Person> = fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(keyPath: \Person.dateOfBirth, ascending: true)]

    return request
  }

}

// MARK: - Generated accessors for events

public extension Person {

  @objc(addEventsObject:)
  @NSManaged
  func addToEvents(_ value: Event)

  @objc(removeEventsObject:)
  @NSManaged
  func removeFromEvents(_ value: Event)

  @objc(addEvents:)
  @NSManaged
  func addToEvents(_ values: NSSet)

  @objc(removeEvents:)
  @NSManaged
  func removeFromEvents(_ values: NSSet)

}

// MARK: - Working with photo

extension Person {

  func setPhoto(_ image: UIImage) {
    let imageData = image.jpegData(compressionQuality: 1)
    photo = imageData
  }

  func getDecodedPhoto() -> UIImage? {
    guard let photoData = photo else { return nil }

    return UIImage(data: photoData)
  }

}
