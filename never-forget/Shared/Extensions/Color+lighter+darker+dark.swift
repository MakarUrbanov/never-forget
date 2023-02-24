//
//  Color+lighter+darker+dark.swift
//  never-forget
//
//  Created by makar on 2/22/23.
//

import SwiftUI

extension Color {

  func lighter(by percentage: Int) -> Color {
    Color(uiColor.lighter(by: percentage))
  }

  func darker(by percentage: Int) -> Color {
    Color(uiColor.darker(by: percentage))
  }

  func dark(_ value: Double) -> Color {
    darker(by: Int(100 * value))
  }

}
