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

  @StateObject var viewModel = MainScreenViewModel()
  @State private var selectedDate = Date.now
  @FetchRequest(fetchRequest: Person.sortedFetchRequest()) private var persons

  var body: some View {
    ZStack(alignment: .top) {
      NeverForgetDatePickerViewRepresentable(selectedDate: $selectedDate, datesOfEvents: viewModel.datesOfEvents)
        .frame(maxWidth: .infinity, maxHeight: 300)

      VStack {
        Text("Upcoming birthdays") // TODO: translate
          .font(.title3)
          .fontWeight(.bold)
          .frame(maxWidth: .infinity, alignment: .leading)

        MainScreenPeopleList(peopleSections: viewModel.peopleListSectioned, selectedDate: $selectedDate)
      }
      .padding(.leading)
      .padding(.bottom, 100)
      .offset(y: 100)
    }
    .onAppear {
      viewModel.onChangePersonsList(persons: persons)
    }
    .onChange(of: Array(persons), perform: { _ in
      viewModel.onChangePersonsList(persons: persons)
    })
    .navigationTitle("Main Tab") // TODO: translate
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.Theme.background)
  }
}

struct MainScreen_Previews: PreviewProvider {
  static var previews: some View {
    MainScreenView()
  }
}
