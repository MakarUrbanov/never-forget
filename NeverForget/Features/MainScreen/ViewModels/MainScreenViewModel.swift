//
//  MainScreenViewModel.swift
//  NeverForgetApp
//
//  Created by makar on 5/18/23.
//

import CoreData
import UIKit

// MARK: - Protocol

protocol MainScreenViewModelProtocol: AnyObject {
  var coordinator: MainScreenCoordinator? { get set }
  var personsSectioned: Bindable<[TableViewPersonsSection]> { get }
  var personsManager: MainScreenPersonsCoreDataManager { get }

  func goToPersonProfile(person: PersonAdapter)
}

// MARK: - ViewModel

final class MainScreenViewModel: MainScreenViewModelProtocol {

  let personsManager: MainScreenPersonsCoreDataManager
  var personsSectioned: Bindable<[TableViewPersonsSection]> = Bindable([])
  weak var coordinator: MainScreenCoordinator?

  init(context: NSManagedObjectContext, fetchRequest: NSFetchRequest<Person>) {
    personsManager = MainScreenPersonsCoreDataManager(context: context, fetchRequest: fetchRequest)
    personsManager.delegate = self
  }

  func goToPersonProfile(person: PersonAdapter) {
    guard let person = try? CoreDataWrapper.shared.backgroundContext
      .existingObject(with: person.objectId) as? Person else
    {
      return
    }
    coordinator?.goToPersonProfile(person: person)
  }

}

// MARK: - CoreDataManager Delegate

extension MainScreenViewModel: MainScreenPersonsCoreDataManagerDelegate {

  func personsChanged(_ persons: [Person]) {
    let sectioned = MainScreenViewModel.generateTableSections(persons: persons)
    personsSectioned.value = sectioned
  }

}

// MARK: - Utils

extension MainScreenViewModel {

  private static func computeNextYearOfDateOfBirth(_ dateOfBirth: Date) -> Int {
    let dateOfBirthComponents = Calendar.current.dateComponents([.month, .day], from: dateOfBirth)

    let nextDateOfBirth = Calendar.current.nextDate(
      after: Date.now,
      matching: dateOfBirthComponents,
      matchingPolicy: .nextTime
    )! // swiftlint:disable:this force_unwrapping

    return Calendar.current.component(.year, from: nextDateOfBirth)
  }

  private static func generateTableSections(persons: [Person]) -> [TableViewPersonsSection] {
    var sectionsDictionary: [PersonsTableSections: [PersonAdapter]] = [:]

    for person in persons {
      let birthday = Calendar.current.dateComponents([.day, .weekOfYear, .month, .year], from: person.dateOfBirth)
      let today = Calendar.current.dateComponents([.day, .weekOfYear, .month, .year], from: Date.now)
      let tomorrow = Calendar.current.dateComponents(
        [.day, .weekOfYear, .month, .year],
        from: Calendar.current.date(
          byAdding: .day,
          value: 1,
          to: Date
            .now
        )! // swiftlint:disable:this force_unwrapping
      )

      let yearOfNextDateOfBirth = computeNextYearOfDateOfBirth(person.dateOfBirth)
      let isNextDateOfBirthInCurrentYear = yearOfNextDateOfBirth == Calendar.current.component(.year, from: Date.now)

      let section: PersonsTableSections

      // swiftlint:disable force_unwrapping
      switch true {
        case birthday.day == today.day && birthday.month == today.month:
          section = .today
        case birthday.day == tomorrow.day && birthday.month == tomorrow.month:
          section = .tomorrow
        case birthday.weekOfYear! == today.weekOfYear! && isNextDateOfBirthInCurrentYear:
          section = .thisWeek
        case birthday.weekOfYear! == today.weekOfYear! + 1:
          section = .nextWeek

        default:
          section = .date(month: birthday.month!, year: yearOfNextDateOfBirth)
      }
      // swiftlint:enable force_unwrapping

      sectionsDictionary[section, default: []].append(PersonAdapter.create(person))
    }

    return sectionsDictionary
      .map {
        TableViewPersonsSection(section: $0.key, persons: $0.value.sorted(by: { $0.dateOfBirth > $1.dateOfBirth }))
      }
      .sorted { $0.section.referenceNumber < $1.section.referenceNumber }
  }

}
