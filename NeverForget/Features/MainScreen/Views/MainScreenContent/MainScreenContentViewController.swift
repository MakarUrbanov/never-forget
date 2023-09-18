//
//  MainScreenContentViewController.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 15.09.2023
//

import UIKit

protocol IMainScreenContentView: UIPageViewController {
  var viewControllersList: [UIViewController] { get }
  var scrollView: UIScrollView? { get }

  func didChangeEvents(_ events: [Event])
}

class MainScreenContentViewController: UIPageViewController, IMainScreenContentView {

  var presenter: IMainScreenContentPresenter

  let eventsCalendar: IEventsCalendarView
  let eventsList: IEventsListView
  var viewControllersList: [UIViewController]
  var scrollView: UIScrollView? {
    for view in view.subviews {
      if let scrollView = view as? UIScrollView {
        return scrollView
      } else {
        return nil
      }
    }

    return nil
  }

  // MARK: - Init
  init(presenter: IMainScreenContentPresenter, eventsService: IEventsCoreDataService) {
    self.presenter = presenter
    eventsCalendar = EventsCalendarModuleBuilder.build(eventsService: eventsService)
    eventsList = EventsListModuleBuilder.build(eventsService: eventsService)
    viewControllersList = [eventsCalendar, eventsList]

    super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Overrides
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .clear

    dataSource = self
    initialize()

    presenter.viewDidLoad()
  }

  // MARK: - Public methods
  func didChangeEvents(_ events: [Event]) {
    eventsCalendar.didChangeEvents()
    eventsList.didChangeEvents()
  }

}

// MARK: - UIPageViewControllerDataSource
extension MainScreenContentViewController: UIPageViewControllerDataSource {

  func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerBefore viewController: UIViewController
  ) -> UIViewController? {
    guard let index = viewControllersList.firstIndex(of: viewController) else { return nil }
    let previousIndex = index - 1

    guard previousIndex >= 0 else { return nil }
    return viewControllersList[previousIndex]
  }

  func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerAfter viewController: UIViewController
  ) -> UIViewController? {
    guard let index = viewControllersList.firstIndex(of: viewController) else { return nil }
    let nextIndex = index + 1

    guard nextIndex < viewControllersList.count else { return nil }
    return viewControllersList[nextIndex]
  }

}

// MARK: - Private methods
private extension MainScreenContentViewController {

  private func initialize() {
    initializeViewControllers()
  }

  private func initializeViewControllers() {
    setViewControllers([viewControllersList[0]], direction: .forward, animated: false)
  }

}
