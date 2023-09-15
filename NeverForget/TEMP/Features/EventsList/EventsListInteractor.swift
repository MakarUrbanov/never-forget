//
//  EventsListInteractor.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 15.09.2023
//

protocol IEventsListInteractor: AnyObject {
}

class EventsListInteractor: IEventsListInteractor {

  weak var presenter: IEventsListPresenter?

}
