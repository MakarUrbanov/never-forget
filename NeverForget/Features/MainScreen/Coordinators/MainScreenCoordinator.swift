//
//  MainScreenCoordinator.swift
//  never-forget
//
//  Created by makar on 2/24/23.
//

import NFLocalNotificationsManager
import SwiftUI
import UIKit

// MARK: - Protocol
protocol IMainScreenCoordinator: NavigationCoordinator {
  func handleDeepLink(_ deepLink: NFLNDeepLink?) // TODO: mmk temp solution
}

// MARK: - Coordinator
final class MainScreenCoordinator: IMainScreenCoordinator, ObservableObject {

  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController = MainScreenNavigationController()

  func start() {
    let mainScreen = Self.initializeMainScreenView()
    navigationController.setViewControllers([mainScreen], animated: false)
  }

}

// MARK: - Navigations
extension MainScreenCoordinator {

  // TODO: mmk remove
  func goToPersonProfile(person: Person) {}

}

// MARK: - Deep link
extension MainScreenCoordinator {

  private func fetchPersonAndGoToProfile(personId: String) {
    do {
      if let person = try Person.fetchPerson(withId: personId, context: CoreDataStack.shared.viewContext) {
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

// MARK: - Static
extension MainScreenCoordinator {

  private static func initializeMainScreenView() -> IMainScreenView {
    let viewController = MainScreenModuleBuilder.build()

    return viewController
  }

}
