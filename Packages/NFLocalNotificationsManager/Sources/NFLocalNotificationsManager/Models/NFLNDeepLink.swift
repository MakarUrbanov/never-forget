//
//  NFLNDeepLink.swift
//
//
//  Created by makar on 5/1/23.
//

import Foundation

public struct NFLNDeepLink: Codable {
  public var link: URL
  public var providedData: [String: String]

  public init(link: URL, providedData: [String: String]) {
    self.link = link
    self.providedData = providedData
  }

  public func dropFirstLinkComponent() -> NFLNDeepLink? {
    let updatedLinkComponents = Array(link.pathComponents.dropFirst())

    if let link = URL(string: updatedLinkComponents.joined(separator: "/")) {
      return NFLNDeepLink(link: link, providedData: providedData)
    }

    return nil
  }

}
