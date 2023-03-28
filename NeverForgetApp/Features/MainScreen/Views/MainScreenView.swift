//
//  MainScreenView.swift
//  never-forget
//
//  Created by makar on 2/5/23.
//

import NeverForgetDatePicker
import SwiftUI

struct MainScreenView: View {
  @Environment(\.colorScheme) var colorScheme

  @State private var selectedDate = Date.now
  @State private var datesOfEvents: Set<Date> = Set()

  var body: some View {
    VStack {
      NeverForgetDatePickerViewRepresentable(selectedDate: $selectedDate, datesOfEvents: datesOfEvents)
        .frame(maxWidth: .infinity, maxHeight: 300)

      Spacer()
    }
    .navigationTitle("Main Tab") // TODO: localize
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.Theme.background)
  }
}

struct MainScreen_Previews: PreviewProvider {
  static var previews: some View {
    MainScreenView()
  }
}
