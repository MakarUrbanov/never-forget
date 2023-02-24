//
//  String+localizedString.swift
//  never-forget
//
//  Created by makar on 2/20/23.
//

import Foundation

extension String {

  static func localizedString(
    for key: String,
    locale: Locale = .current
  ) -> String {
    let language = locale.languageCode
    guard let path = Bundle.main.path(forResource: language, ofType: "lproj"),
          let bundle = Bundle(path: path) else { fatalError(#function) }

    let localizedString = NSLocalizedString(key, bundle: bundle, comment: "")

    return localizedString
  }

}
