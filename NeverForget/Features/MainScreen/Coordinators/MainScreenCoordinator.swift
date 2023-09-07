//
//  MainScreenCoordinator.swift
//  never-forget
//
//  Created by makar on 2/24/23.
//

import NFLocalNotificationsManager
import SwiftUI
import UIKit

final class MainScreenCoordinator: NavigationCoordinator, ObservableObject {
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController = .init()

  func start() {
    let mainScreen = initializeMainScreenView()
    navigationController.setViewControllers([mainScreen], animated: false)
  }

}

// MARK: - Navigations
extension MainScreenCoordinator {

  func goToPersonProfile(person: Person) {
    let view = ContactProfileView(person: person, goBack: {
      self.navigationController.navigate(step: .pop)
    })
    .environmentObject(self)
    .environment(\.managedObjectContext, CoreDataWrapper.shared.viewContext)

    let addNewPersonView = UIHostingController(rootView: view)
    navigationController.navigate(step: .push(addNewPersonView))
  }

}

// MARK: - Deep link
extension MainScreenCoordinator {

  private func fetchPersonAndGoToProfile(personId: String) {
    do {
      if let person = try Person.fetchPerson(withId: personId, context: CoreDataWrapper.shared.viewContext) {
        goToPersonProfile(person: person)
      }
    } catch {
      Logger.error(message: "Can't fetch the person by personId", error)
    }
  }

  func handleDeepLink(_ deepLink: NFLNDeepLink?) {
    guard let deepLink, let deepLinkComponents = deepLink.link.getDeepLinkComponents() else { return }

    switch deepLinkComponents.first {
      case .personProfile:
        guard let personId = deepLink.providedData["personId"] else { return }

        fetchPersonAndGoToProfile(personId: personId)

      default:
        break
    }
  }

}

// MARK: - Utils
extension MainScreenCoordinator {

  private func initializeMainScreenView() -> UIViewController {
    let viewController = NewMainScreenViewController()
    viewController.navigationItem.title = String(localized: "Main")

    return viewController
  }

}
