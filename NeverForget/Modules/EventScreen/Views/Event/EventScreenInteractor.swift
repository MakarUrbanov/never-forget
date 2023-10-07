//
//  EventScreenInteractor.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 29.09.2023
//

protocol IEventScreenInteractorInput: AnyObject {
}

protocol IEventScreenInteractorOutput: AnyObject {
}

class EventScreenInteractor: IEventScreenInteractorInput {

  weak var presenter: IEventScreenInteractorOutput?

}
