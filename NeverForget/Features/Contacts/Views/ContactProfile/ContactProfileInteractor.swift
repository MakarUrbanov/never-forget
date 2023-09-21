//
//  ContactProfileInteractor.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 21.09.2023
//

protocol IContactProfileInteractor: AnyObject {
}

class ContactProfileInteractor: IContactProfileInteractor {

  weak var presenter: IContactProfilePresenter?

  var contact: Contact

  init(contact: Contact) {
    self.contact = contact
  }

}
