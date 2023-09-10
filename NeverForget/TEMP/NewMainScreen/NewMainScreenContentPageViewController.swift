//
//  NewMainScreenContentPageViewController.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 08.09.2023.
//

import UIKit

// MARK: - Protocols
protocol INewMainScreenContentPageViewControllerDelegate: AnyObject {
  func pageView(_ pageView: INewMainScreenContentPageViewController, page: Int, changePosition: CGFloat)
}

protocol INewMainScreenContentPageViewController: UIPageViewController {
  var viewControllersList: [UIViewController] { get }
  var customDelegate: INewMainScreenContentPageViewControllerDelegate? { get set }
}

// MARK: - NewMainScreenContentPageViewController
class NewMainScreenContentPageViewController: UIPageViewController, INewMainScreenContentPageViewController {

  var viewControllersList: [UIViewController] = []
  weak var customDelegate: INewMainScreenContentPageViewControllerDelegate?

  override func viewDidLoad() {
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
    viewControllerAfter viewController: UIViewController
  ) -> UIViewController? {
    guard let index = viewControllersList.firstIndex(of: viewController) else { return nil }
    let previousIndex = index - 1

    guard previousIndex >= 0 else { return nil }
    return viewControllersList[previousIndex]
  }

  func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerBefore viewController: UIViewController
  ) -> UIViewController? {
    guard let index = viewControllersList.firstIndex(of: viewController) else { return nil }
    let nextIndex = index + 1

    guard nextIndex < viewControllersList.count else { return nil }
    return viewControllersList[nextIndex]
  }

}

// MARK: - UIScrollViewDelegate
extension NewMainScreenContentPageViewController: UIScrollViewDelegate {
  // TODO: mmk finish logic
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentSize.width > scrollView.frame.width {
      let page = scrollView.contentOffset.x / scrollView.frame.width
      print("mmk HOR", page)
    } else if scrollView.contentSize.height > scrollView.frame.height {
      let page = scrollView.contentOffset.y / scrollView.frame.height
      print("mmk VER", page)
    }
  }
}

// MARK: - Private methods
private extension NewMainScreenContentPageViewController {

  private func initialize() {
    initializeViewControllers()
    setupPageScrollDelegate()
  }

  private func initializeViewControllers() {
    let eventsCalendar = EventsCalendarViewController()

    viewControllersList = [Self.testViewController, eventsCalendar]

    setViewControllers([eventsCalendar], direction: .forward, animated: false)
  }

  private func setupPageScrollDelegate() {
    for view in view.subviews {
      if let scrollView = view as? UIScrollView {
        scrollView.delegate = self
      }
    }
  }

}
