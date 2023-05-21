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
  @EnvironmentObject var coordinator: MainScreenCoordinator

  var body: some View {
    VStack {
      Text("Upcoming birthdays") // TODO: translate
        .font(.title3)
        .fontWeight(.bold)
        .frame(maxWidth: .infinity, alignment: .leading)

      MainScreenContactsListView(peopleSections: viewModel.peopleListSectioned)
        .padding(.trailing)
    }
    .padding(.leading)
    .onAppear {
      viewModel.onChangePersonsList(persons: Array(persons))
    }
    .onChange(of: Array(persons), perform: { newPersons in
      viewModel.onChangePersonsList(persons: newPersons)
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
