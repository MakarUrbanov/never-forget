//
//  MainScreenPeopleList.swift
//  NeverForgetApp
//
//  Created by makar on 3/29/23.
//

import SwiftUI

struct MainScreenPeopleList: View {

  @EnvironmentObject var coordinator: MainScreenCoordinator
  private let peopleSections: [PeopleListSectioned]
  @Binding var selectedDate: Date

  init(peopleSections: [PeopleListSectioned], selectedDate: Binding<Date>) {
    _selectedDate = selectedDate
    self.peopleSections = peopleSections
  }

  var body: some View {
    ScrollView {
      LazyVStack(spacing: 20) {
        ForEach(peopleSections) { peopleSection in
          MainScreenPeopleSection(section: peopleSection, goToPersonProfile: coordinator.goToPersonProfile(person:))
        }
      }
    }
  }
}


struct MainScreenPeopleList_Previews: PreviewProvider {
  static var previews: some View {
    MainScreenPeopleList(peopleSections: [], selectedDate: .constant(Date.now))
      .environmentObject(MainScreenCoordinator())
  }
}
