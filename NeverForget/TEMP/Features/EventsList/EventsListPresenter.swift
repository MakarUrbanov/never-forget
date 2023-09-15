//
//  EventsListPresenter.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 15.09.2023
//

protocol IEventsListPresenter: AnyObject {
  func viewDidLoad()
}

class EventsListPresenter: IEventsListPresenter {

  weak var view: IEventsListView?
  var router: IEventsListRouter
  var interactor: IEventsListInteractor
  
  init(interactor: IEventsListInteractor, router: IEventsListRouter) {
    self.interactor = interactor
    self.router = router
  }

  // MARK: - Public methods
  func viewDidLoad() {
  }

}
