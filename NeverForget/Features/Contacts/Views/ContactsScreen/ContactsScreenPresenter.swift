//
//  ContactsScreenPresenter.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 18.09.2023
//

protocol IContactsScreenPresenter: AnyObject {
  func viewDidLoad()
}

class ContactsScreenPresenter: IContactsScreenPresenter {

  weak var view: IContactsScreenView?
  var router: IContactsScreenRouter
  var interactor: IContactsScreenInteractor

  init(interactor: IContactsScreenInteractor, router: IContactsScreenRouter) {
    self.interactor = interactor
    self.router = router
  }

  // MARK: - Public methods
  func viewDidLoad() {}

}
