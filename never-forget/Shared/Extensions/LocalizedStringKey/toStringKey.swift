//
//  toStringKey.swift
//  never-forget
//
//  Created by makar on 2/20/23.
//

import SwiftUI

extension LocalizedStringKey {

  var toStringKey: String {
    Mirror(reflecting: self).children.first(where: { $0.label == "key" })?.value as? String ?? ""
  }

}
