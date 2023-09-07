//
//  TouchableOpacityButtonStyle.swift
//  never-forget
//
//  Created by makar on 3/5/23.
//

import SwiftUI

struct TouchableOpacityButtonStyle: ButtonStyle {
  let opacity: Double

  init(opacity: Double = 0.8) {
    self.opacity = opacity
  }

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .opacity(configuration.isPressed ? opacity : 1)
  }
}
