//
//  EventsListInteractor.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 15.09.2023
//

import Foundation
import SwiftDate

protocol IEventsListInteractor: AnyObject {
  var eventsService: IEventsCoreDataService { get }
  var events: [Event] { get }
  var listDates: [Date] { get }

  func fetchEvents()
}

class EventsListInteractor: IEventsListInteractor {

  weak var presenter: IEventsListPresenter?

  var eventsService: IEventsCoreDataService
  var events: [Event] {
    eventsService.events
  }

  var listDates: [Date]

  init(eventsService: IEventsCoreDataService) {
    self.eventsService = eventsService
    listDates = Self.generateListDates(startFrom: DateInRegion(region: .current).date)
  }

  func fetchEvents() {
    eventsService.fetchEvents()
  }

}

// MARK: - Static
extension EventsListInteractor {

  enum Constants {
    static let VISIBLE_MONTHS = 3
  }

  private static func generateListDates(startFrom: Date) -> [Date] {
    let dateTo = startFrom + Constants.VISIBLE_MONTHS.months
    let daysDifference = Int(startFrom.getInterval(toDate: dateTo, component: .day))

    return (0..<daysDifference).map { startFrom + $0.days }
  }

}
