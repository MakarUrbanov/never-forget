//
//  EventsListPresenter.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 15.09.2023
//

import Foundation

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
    interactor.listDates.count
  }

  func getDate(at index: IndexPath) -> Date {
    interactor.listDates[index.item]
  }

  func getEvents(for date: Date) -> [Event] {
    // TODO: mmk impl
    return []
  }


  func didFetchEvents() {
    view?.didFetchEvents()
  }

}
