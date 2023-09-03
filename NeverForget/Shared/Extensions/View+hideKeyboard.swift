//
//  View+hideKeyboard.swift
//  never-forget
//
//  Created by makar on 3/5/23.
//

import SwiftUI

extension View {

  func hideKeyboard() {
    let resign = #selector(UIResponder.resignFirstResponder)
    UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
  }

}
