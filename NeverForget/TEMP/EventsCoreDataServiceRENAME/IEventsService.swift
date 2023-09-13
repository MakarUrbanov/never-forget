//
//  IEventsService.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 13.09.2023.
//

import Foundation

protocol IEventsService {
  var events: [Event] { get }

  func fetchEvents() throws -> [Event]
  func saveEvent(_ event: Event) throws
  func deleteEvent(_ event: Event) throws
}
