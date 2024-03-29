//
//  IEventsService.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 13.09.2023.
//

import Foundation

protocol IEventsService {
  var events: [Event] { get }

  @discardableResult
  func fetchEvents() -> [Event]
  func saveChanges()
  func revertChanges()
  func deleteEvent(_ event: Event)
}
