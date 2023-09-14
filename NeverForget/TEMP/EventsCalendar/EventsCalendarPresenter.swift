//
//  EventsCalendarPresenter.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 15.09.2023
//

protocol IEventsCalendarPresenter: AnyObject {
  func viewDidLoad()
}

class EventsCalendarPresenter: IEventsCalendarPresenter {

  weak var view: IEventsCalendarView?
  var router: IEventsCalendarRouter
  var interactor: IEventsCalendarInteractor

  init(interactor: IEventsCalendarInteractor, router: IEventsCalendarRouter) {
    self.interactor = interactor
    self.router = router
  }

  // MARK: - Public methods
  func viewDidLoad() {}

}
