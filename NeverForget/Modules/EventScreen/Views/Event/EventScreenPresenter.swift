//
//  EventScreenPresenter.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 29.09.2023
//

protocol IEventScreenPresenterInput: AnyObject {
  func goBack()
}

protocol IEventScreenPresenterOutput: AnyObject {
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

  func goBack() {
    router.goBack()
  }

}

// MARK: - IEventScreenInteractorOutput
extension EventScreenPresenter: IEventScreenInteractorOutput {
}
