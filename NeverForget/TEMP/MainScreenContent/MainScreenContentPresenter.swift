//
//  MainScreenContentPresenter.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 15.09.2023
//

protocol IMainScreenContentPresenter: AnyObject {
  func viewDidLoad()
  func didChangeEvents(_ events: [Event])
}

class MainScreenContentPresenter: IMainScreenContentPresenter {

  weak var view: IMainScreenContentView?
  var router: IMainScreenContentRouter
  var interactor: IMainScreenContentInteractor

  init(interactor: IMainScreenContentInteractor, router: IMainScreenContentRouter) {
    self.interactor = interactor
    self.router = router
  }

  // MARK: - Public methods
  func viewDidLoad() {}

  func didChangeEvents(_ events: [Event]) {
    view?.showEvents(events)
  }

}
