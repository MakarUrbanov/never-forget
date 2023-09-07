//
//  AppPreloader.swift
//  never-forget
//
//  Created by makar on 3/24/23.
//

import SwiftUI

struct AppPreloader: View {
  var body: some View {
    Rectangle()
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .foregroundColor(Color(.background))
      .overlay {
        ProgressView()
          .scaleEffect(2)
          .tint(Color(.accent))
      }
  }
}

struct AppPreloader_Previews: PreviewProvider {
  static var previews: some View {
    AppPreloader()
  }
}
