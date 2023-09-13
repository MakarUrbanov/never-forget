//
//  NewMainScreenContentViewModel.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 13.09.2023.
//

import CoreData
import NFCore

// MARK: - Delegate
protocol INewMainScreenContentViewModelDelegate: AnyObject {

}

// MARK: - Protocol
protocol INewMainScreenContentViewModel: AnyObject {
  var eventsService: IEventsCoreDataService { get }
  var events: Bindable<Set<Event>> { get }

  var delegate: INewMainScreenContentViewModelDelegate? { get set }

  init(context: NSManagedObjectContext, fetchRequest: NSFetchRequest<Event>)
}

// MARK: - NewMainScreenContentViewModel
final class NewMainScreenContentViewModel: INewMainScreenContentViewModel {

  var eventsService: IEventsCoreDataService
  var events: Bindable<Set<Event>> = Bindable([])

  weak var delegate: INewMainScreenContentViewModelDelegate?

  init(
    context: NSManagedObjectContext = DEFAULT_CONTEXT,
    fetchRequest: NSFetchRequest<Event> = DEFAULT_FETCH_REQUEST
  ) {
    eventsService = EventsCoreDataService(context: context, fetchRequest: fetchRequest)

    eventsService.delegate = self
    eventsService.fetchEvents()
  }

}

// MARK: - IEventsCoreDataServiceDelegate
extension NewMainScreenContentViewModel: IEventsCoreDataServiceDelegate {

  func eventsChanged(_ events: [Event]) {
    self.events.value = Set(events)
  }

}

// MARK: - Static
extension NewMainScreenContentViewModel {

  private static let DEFAULT_CONTEXT = CoreDataStack.shared.viewContext
  private static let DEFAULT_FETCH_REQUEST = Event.fetchRequestWithSorting(
    descriptors: [.init(keyPath: \Event.date, ascending: true)]
  )

}
