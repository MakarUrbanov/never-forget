//
//  EventScreenPresenter.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 29.09.2023
//

import Foundation

protocol IEventScreenPresenterInput: AnyObject {
  func viewDidLoad()
  func goBack()
  func getOriginDate() -> Date
  func didChangeOriginDate(_ newDate: Date)
}

protocol IEventScreenPresenterOutput: AnyObject {
  func setOriginDate(_ date: Date)
}

class EventScreenPresenter {

  weak var view: IEventScreenPresenterOutput?
  var router: IEventScreenRouter
  var interactor: IEventScreenInteractorInput

  init(interactor: IEventScreenInteractorInput, router: IEventScreenRouter) {
    self.interactor = interactor
    self.router = router
  }

}

// MARK: - IEventScreenPresenterInput
extension EventScreenPresenter: IEventScreenPresenterInput {

  func viewDidLoad() {
    let originDate = interactor.getOriginDate()
    view?.setOriginDate(originDate)
  }

  func goBack() {
    router.goBack()
  }

  func getOriginDate() -> Date {
    interactor.getOriginDate()
  }

  func didChangeOriginDate(_ newDate: Date) {
    let date = newDate.inDefaultRegion().date
    interactor.setOriginDate(date: date)
    view?.setOriginDate(date)
  }

}

// MARK: - IEventScreenInteractorOutput
extension EventScreenPresenter: IEventScreenInteractorOutput {
}
