//
//  MainScreenContentInteractor.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 15.09.2023
//

protocol IMainScreenContentInteractor: AnyObject {
  var eventsService: IEventsCoreDataService { get }
}

class MainScreenContentInteractor: IMainScreenContentInteractor {

  var eventsService: IEventsCoreDataService

  weak var presenter: IMainScreenContentPresenter?

  init(eventsService: IEventsCoreDataService) {
    self.eventsService = eventsService
    self.eventsService.delegate = self
    self.eventsService.fetchEvents()
  }

}

// MARK: - IEventsCoreDataServiceDelegate
extension MainScreenContentInteractor: IEventsCoreDataServiceDelegate {

  func eventsChanged(_ events: [Event]) {
    presenter?.didChangeEvents(events)
  }

}
