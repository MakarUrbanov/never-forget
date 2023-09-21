//
//  ContactProfilePresenter.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 21.09.2023
//

protocol IContactProfilePresenter: AnyObject {
  func viewDidLoad()
}

class ContactProfilePresenter: IContactProfilePresenter {

  var router: IContactProfileRouter
  var interactor: IContactProfileInteractor

  weak var view: IContactProfileView?

  init(interactor: IContactProfileInteractor, router: IContactProfileRouter) {
    self.interactor = interactor
    self.router = router
  }

  // MARK: - Public methods
  func viewDidLoad() {
  }

}
