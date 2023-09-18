//
//  EventsCalendarInteractor.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 15.09.2023
//

import Foundation

protocol IEventsCalendarInteractor: AnyObject {
  var eventsService: IEventsCoreDataService { get }
}

class EventsCalendarInteractor: IEventsCalendarInteractor {

  var eventsService: IEventsCoreDataService

  weak var presenter: IEventsCalendarPresenter?

  init(eventsService: IEventsCoreDataService) {
    self.eventsService = eventsService
    eventsService.addObserver(target: self, selector: #selector(didChangeEvents))
  }

}

// MARK: - Private methods
extension EventsCalendarInteractor {

  @objc
  private func didChangeEvents(_ notification: Notification) {
    presenter?.didChangeEvents()
  }

}
