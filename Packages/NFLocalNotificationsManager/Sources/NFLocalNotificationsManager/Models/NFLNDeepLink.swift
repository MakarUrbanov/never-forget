//
//  NFLNDeepLink.swift
//
//
//  Created by makar on 5/1/23.
//

import Foundation

public struct NFLNDeepLink {
  let link: URL
  let providedData: [String: Any]

  public init(link: URL, providedData: [String: Any]) {
    self.link = link
    self.providedData = providedData
  }

}
