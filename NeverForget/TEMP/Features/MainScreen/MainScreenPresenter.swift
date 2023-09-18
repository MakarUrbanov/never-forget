//
//  MainScreenPresenter.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 14.09.2023
//

protocol IMainScreenPresenter: AnyObject {
  func viewDidLoad()
}

class MainScreenPresenter: IMainScreenPresenter {
  weak var view: IMainScreenView?
  var router: IMainScreenRouter
  var interactor: IMainScreenInteractor

  init(interactor: IMainScreenInteractor, router: IMainScreenRouter) {
    self.interactor = interactor
    self.router = router
  }

  // MARK: - Public methods
  func viewDidLoad() {}
}
