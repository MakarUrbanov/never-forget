//
//  NewMainScreenContentPageViewController.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 08.09.2023.
//

import UIKit

// MARK: - Protocols
protocol INewMainScreenContentPageViewController: UIPageViewController {
  var eventsCalendar: IEventsCalendarViewController { get }
  var viewControllersList: [UIViewController] { get }
  var scrollView: UIScrollView? { get }
}

// MARK: - NewMainScreenContentPageViewController
class NewMainScreenContentPageViewController: UIPageViewController, INewMainScreenContentPageViewController {

  // MARK: - Public properties
  let eventsCalendar: IEventsCalendarViewController = EventsCalendarViewController()
  var viewControllersList: [UIViewController] = []
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

  // MARK: - Public methods
  override func viewDidLoad() {
    viewControllersList = [eventsCalendar, Self.testViewController]
    super.viewDidLoad()

    dataSource = self

    initialize()
  }

}

// MARK: - UIPageViewControllerDataSource
extension NewMainScreenContentPageViewController: UIPageViewControllerDataSource {

  // TODO: mmk remove
  private static let testViewController: UIViewController = {
    let view = UIViewController()
    view.view.backgroundColor = UIColor(resource: .darkBackground)
    let label = UILabel()
    label.text = "Second VC"
    view.view.addSubview(label)
    label.textAlignment = .center
    label.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    return view
  }()

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
private extension NewMainScreenContentPageViewController {

  private func initialize() {
    initializeViewControllers()
  }

  private func initializeViewControllers() {
    setViewControllers([viewControllersList[0]], direction: .forward, animated: false)
  }

}
