//
//  Color+random.swift
//  NeverForgetApp
//
//  Created by makar on 4/2/23.
//

import SwiftUI

extension Color {

  static var random: Color {
    Color(
      red: .random(in: 0 ... 1),
      green: .random(in: 0 ... 1),
      blue: .random(in: 0 ... 1)
    )
  }

}
