//
//  NFLNScheduledEventNotification.swift
//
//
//  Created by makar on 5/1/23.
//

import Foundation

public struct NFLNScheduledEventNotification {
  public let identifier: String
  public let title: String
  public let body: String
  public let date: Date
  public let deepLink: NFLNDeepLink?
  public let categoryIdentifier: String?
  public let image: Data?

  public init(
    identifier: String,
    title: String,
    body: String,
    date: Date,
    deepLink: NFLNDeepLink?,
    categoryIdentifier: String?,
    image: Data?
  ) {
    self.identifier = identifier
    self.title = title
    self.body = body
    self.date = date
    self.deepLink = deepLink
    self.categoryIdentifier = categoryIdentifier
    self.image = image
  }

}
