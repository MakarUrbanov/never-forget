//
//  EventsListRouter.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 15.09.2023
//

protocol IEventsListRouter: AnyObject {
}

class EventsListRouter: IEventsListRouter {

  weak var viewController: IEventsListView?

}
