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
  @FetchRequest(fetchRequest: Person.sortedFetchRequest()) var persons
  private var datesOfEvents: Set<Date> {
    var set: Set<Date> = Set()

    persons.forEach { person in
      guard let dateOfBirth = person.dateOfBirth else { fatalError("Person entity should have dateOfBirth property") }
      set.insert(dateOfBirth)
    }

    return set
  }

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
