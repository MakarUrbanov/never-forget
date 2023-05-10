//
//  MainScreenViewModel.swift
//  NeverForgetApp
//
//  Created by makar on 4/3/23.
//

import Foundation
import SwiftUI

class MainScreenViewModel: ObservableObject {

  @Published var peopleListSectioned: [PeopleListSectioned] = []
  @Published var datesOfEvents: Set<Date> = []

  func onChangePersonsList(persons: [Person]) {
    let sectionedPersonsList = MainScreenViewModel.createSectionedPersonsList(persons)
    peopleListSectioned = sectionedPersonsList

    datesOfEvents = MainScreenViewModel.computeDatesOfEvents(persons: persons)
  }

}

// MARK: - Utils

extension MainScreenViewModel {

  private static func computeDatesOfEvents(persons: [Person]) -> Set<Date> {
    var set: Set<Date> = Set()

    persons.forEach { person in
      set.insert(person.dateOfBirth)
    }

    return set
  }

}

// MARK: - Sorting

extension MainScreenViewModel {

  private static func checkIsDatesMonthInFutureInCurrentYear(_ date: Date) -> Bool {
    var dateComponentsFromDate = Calendar.current.dateComponents(in: .current, from: date)
    let currentYear = Calendar.current.component(.year, from: Date.now)
    dateComponentsFromDate.year = currentYear

    let dateComponentsToMatch = Calendar.current.dateComponents(
      [.month, .day],
      from: dateComponentsFromDate.date ?? Date.now
    )
    let nextDate = Calendar.current.nextDate(
      after: Date.now,
      matching: dateComponentsToMatch,
      matchingPolicy: .nextTime,
      repeatedTimePolicy: .first,
      direction: .forward
    )

    guard let nextDate else { return false }

    return Calendar.current.component(.year, from: nextDate) == currentYear
  }

  private static func createSectionedPersonsList(_ persons: [Person]) -> [PeopleListSectioned] {
    let currentMonth = Calendar.current.component(.month, from: Date.now)
    let todayBirthdays = PeopleListSectioned(title: "Today:", month: currentMonth, persons: []) // TODO: translate
    let tomorrowBirthdays = PeopleListSectioned(title: "Tomorrow:", month: currentMonth, persons: []) // TODO: translate
    var listSectioned: [String: PeopleListSectioned] = ["today": todayBirthdays, "tomorrow": tomorrowBirthdays]

    persons.forEach { person in
      let personsDateOfBirth = person.dateOfBirth
      let personsMonthOfDateOfBirth = Calendar.current.component(.month, from: personsDateOfBirth)
      let isDateOfBirthInThisYear = checkIsDatesMonthInFutureInCurrentYear(personsDateOfBirth)
      let sectionIndexByMonth = isDateOfBirthInThisYear ? personsMonthOfDateOfBirth : 12 + personsMonthOfDateOfBirth
      let nextYear: Int = {
        let modifiedDate = Calendar.current.date(byAdding: .year, value: 1, to: Date.now) ?? Date.now
        return Calendar.current.component(.year, from: modifiedDate)
      }()

      let formattedMonth = DateFormatter(dateFormat: "LLLL").string(from: personsDateOfBirth).capitalizeFirst()

      let title = isDateOfBirthInThisYear
        ? "\(formattedMonth):"
        : "\(formattedMonth) \(nextYear):"

      if var existingSection = listSectioned[title] {
        existingSection.pushPerson(person)
        listSectioned.updateValue(existingSection, forKey: title)
      } else {
        let section = PeopleListSectioned(title: title, month: sectionIndexByMonth, persons: [person])
        listSectioned[title] = section
      }
    }

    let sortedList = Array(listSectioned.values)
      .filter { section in
        !section.persons.isEmpty
      }
      .sorted { person1, person2 in
        person1.month < person2.month
      }

    return sortedList
  }

}
