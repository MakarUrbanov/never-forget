//
//  NFLNScheduledEventNotification.swift
//
//
//  Created by makar on 5/1/23.
//

import Foundation

public struct NFLNScheduledEventNotification {
  let identifier: String
  let title: String
  let body: String
  let date: Date
  let deepLink: NFLNDeepLink?
  let categoryIdentifier: String?

  public init(
    identifier: String,
    title: String,
    body: String,
    date: Date,
    deepLink: NFLNDeepLink?,
    categoryIdentifier: String?
  ) {
    self.identifier = identifier
    self.title = title
    self.body = body
    self.date = date
    self.deepLink = deepLink
    self.categoryIdentifier = categoryIdentifier
  }

}
