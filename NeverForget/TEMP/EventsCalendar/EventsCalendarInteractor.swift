//
//  EventsCalendarInteractor.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 15.09.2023
//

protocol IEventsCalendarInteractor: AnyObject {}

class EventsCalendarInteractor: IEventsCalendarInteractor {
  weak var presenter: IEventsCalendarPresenter?
}
