//
//  ContactsScreenRouter.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 18.09.2023
//

protocol IContactsScreenRouter: AnyObject {}

class ContactsScreenRouter: IContactsScreenRouter {

  weak var viewController: IContactsScreenView?

}
