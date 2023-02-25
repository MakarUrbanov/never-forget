//
//  MainScreenView.swift
//  never-forget
//
//  Created by makar on 2/5/23.
//

import SwiftUI

struct MainScreenView: View {
  var body: some View {
    VStack {
      Text("Main tab")
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.Theme.background)
  }
}

struct MainScreen_Previews: PreviewProvider {
  static var previews: some View {
    MainScreenView()
  }
}
