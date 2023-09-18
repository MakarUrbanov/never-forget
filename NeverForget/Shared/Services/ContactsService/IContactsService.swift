//
//  IContactsService.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 18.09.2023.
//

import Foundation

protocol IContactsService: AnyObject {
  var contacts: [Contact] { get }

  @discardableResult
  func fetchContacts() -> [Event]
  func saveChanges()
  func deleteEvent(_ event: Event)
}
