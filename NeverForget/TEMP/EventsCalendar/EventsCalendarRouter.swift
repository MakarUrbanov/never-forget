//
//  EventsCalendarRouter.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 15.09.2023
//

protocol IEventsCalendarRouter: AnyObject {}

class EventsCalendarRouter: IEventsCalendarRouter {
  weak var viewController: IEventsCalendarView?
}
