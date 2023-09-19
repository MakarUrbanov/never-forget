//
//  EventsListPresenter.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 15.09.2023
//

import UIKit

protocol IEventsListPresenter: AnyObject {
  var interactor: IEventsListInteractor { get set }

  func viewDidLoad()
  func getDatesCount() -> Int
  func getDate(at index: IndexPath) -> Date
  func getEvents(for date: Date) -> [Event]

  func didFetchEvents()
}

class EventsListPresenter: IEventsListPresenter {

  weak var view: IEventsListView?
  var router: IEventsListRouter
  var interactor: IEventsListInteractor

  init(interactor: IEventsListInteractor, router: IEventsListRouter) {
    self.interactor = interactor
    self.router = router
  }

  func viewDidLoad() {
    interactor.fetchEvents()
  }

  func getDatesCount() -> Int {
    interactor.renderDatesList.count
  }

  func getDate(at index: IndexPath) -> Date {
    interactor.renderDatesList[index.item]
  }

  func getEvents(for date: Date) -> [Event] {
    // TODO: mmk delete
    let isMock = Double.random(in: 0...1) > 0.9

    if isMock {
      let contact = Contact(context: CoreDataStack.shared.backgroundContext)
      contact.firstName = "Makar"
      contact.lastName = "Mishchenko"
      contact.photoData = UIImage(resource: .mock).pngData()
      let event = contact.createLinkedEvent()
      event.name = "Date of birth"
      let event2 = contact.createLinkedEvent()
      let event3 = contact.createLinkedEvent()
      let event4 = contact.createLinkedEvent()
      let event5 = contact.createLinkedEvent()

      return Bool.random() ? [event] : [event, event2, event3, event4, event5]
    }

    return []
  }

  func didFetchEvents() {
    view?.didChangeEvents()
  }

}
