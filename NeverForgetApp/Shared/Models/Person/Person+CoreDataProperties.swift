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

// MARK: - Working with photo

extension Person {

  func getDecodedPhoto() -> UIImage? {
    guard let photoData = photo else { return nil }

    return UIImage(data: photoData)
  }

}
