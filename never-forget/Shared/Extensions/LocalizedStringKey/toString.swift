//
//  toString.swift
//  never-forget
//
//  Created by makar on 2/20/23.
//

import SwiftUI

extension LocalizedStringKey {

  func toString(locale: Locale = .current) -> String {
    return .localizedString(for: toStringKey, locale: locale)
  }

}
