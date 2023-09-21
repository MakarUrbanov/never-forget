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
  func fetchContacts() -> [Contact]
  func saveChanges()
  func revertChanges()
  func deleteContact(_ contact: Contact)

}
