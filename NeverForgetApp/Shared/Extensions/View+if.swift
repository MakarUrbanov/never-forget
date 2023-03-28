//
//  View+if.swift
//  never-forget
//
//  Created by makar on 3/12/23.
//

import SwiftUI

extension View {

  @ViewBuilder  func `if`(_ condition: Bool, transform: @escaping (Self) -> some View) -> some View {
    if condition {
      transform(self)
    } else {
      self
    }
  }

}
