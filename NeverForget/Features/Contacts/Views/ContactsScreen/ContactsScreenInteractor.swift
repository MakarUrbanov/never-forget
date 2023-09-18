//
//  ContactsScreenInteractor.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 18.09.2023
//

protocol IContactsScreenInteractor: AnyObject {}

class ContactsScreenInteractor: IContactsScreenInteractor {

  weak var presenter: IContactsScreenPresenter?

}
