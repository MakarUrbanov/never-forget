//
//  MainScreenViewController.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 14.09.2023
//

import UIKit

protocol IMainScreenView: UIViewController {}

class MainScreenViewController: UIViewController, IMainScreenView {

  var presenter: IMainScreenPresenter?

  let pageHeader: IMainScreenHeaderView
  var contentPageViewController: IMainScreenContentView

  init() {
    pageHeader = MainScreenHeaderView()
    contentPageViewController = Self.initializeContentPageViewController()

    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .clear

    initialize()
    presenter?.viewDidLoad()
  }
}

// MARK: - UIScrollViewDelegate
extension MainScreenViewController: UIScrollViewDelegate {
  // TODO: mmk finish logic
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let currentSelectedViewIndex = CGFloat(pageHeader.pageSwitcher.currentSelectedButtonIndex)
    let pageOffset = scrollView.contentOffset.x / scrollView.frame.width - 1 + currentSelectedViewIndex

    if !pageHeader.pageSwitcher.isAnimating {
      pageHeader.pageSwitcher.setSelectAnimated(pageOffset)
    }
  }
}

// MARK: - UIPageViewControllerDelegate
extension MainScreenViewController: UIPageViewControllerDelegate {

  func pageViewController(
    _ pageViewController: UIPageViewController,
    didFinishAnimating finished: Bool,
    previousViewControllers: [UIViewController],
    transitionCompleted completed: Bool
  ) {
    guard
      let currentViewController = contentPageViewController.viewControllers?.last,
      completed,
      finished,
      let newViewControllerIndex = contentPageViewController.viewControllersList
      .firstIndex(of: currentViewController) else
    {
      return
    }

    let button = pageHeader.pageSwitcher.buttons[newViewControllerIndex]
    pageHeader.pageSwitcher.select(button: button, animated: false)
  }

}

// MARK: - IViewsSwitcherViewDelegate
extension MainScreenViewController: IViewsSwitcherViewDelegate {

  func viewsSwitcher(
    _ switcher: IViewsSwitcherView,
    didSelect button: SwitcherButtonData,
    previousSelectedButton previousButton: SwitcherButtonData
  ) {
    let direction: UIPageViewController.NavigationDirection = previousButton.index < button.index ? .forward : .reverse
    let viewController = contentPageViewController.viewControllersList[button.index]
    contentPageViewController.setViewControllers([viewController], direction: direction, animated: true)
  }

}

// MARK: - Private methods
private extension MainScreenViewController {

  private func initialize() {
    initializeNavigationHeader()
    initializePageHeader()
    initializeContentPageViewController()
  }

  private func initializeNavigationHeader() {
    let leftBarItem = UIBarButtonItem(customView: TodayDateView())
    navigationItem.setLeftBarButton(leftBarItem, animated: false)

    let rightBarItem = UIBarButtonItem(customView: NotificationsButton(withBadge: true))
    navigationItem.setRightBarButton(rightBarItem, animated: false)
  }

  private func initializePageHeader() {
    pageHeader.pageSwitcher.delegate = self

    view.addSubview(pageHeader)

    pageHeader.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.width.equalToSuperview().inset(UIConstants.pageHorizontalInset)
      make.height.equalTo(UIConstants.pageHeaderHeight)
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(UIConstants.headerOffset)
    }
  }

  private func initializeContentPageViewController() {
    contentPageViewController.delegate = self
    setupPageScrollViewSettings()

    addChild(contentPageViewController)
    view.addSubview(contentPageViewController.view)
    contentPageViewController.didMove(toParent: self)

    contentPageViewController.view.snp.makeConstraints { make in
      make.top.equalTo(pageHeader.snp.bottom)
      make.left.right.equalToSuperview()
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
    }
  }

  private func setupPageScrollViewSettings() {
    contentPageViewController.scrollView?.delegate = self
  }

}

// MARK: - Static
extension MainScreenViewController {

  enum UIConstants {
    static let pageHorizontalInset = 16
    static let headerOffset = 20
    static let pageHeaderHeight = 60
    static let dividerHeight = UIConstants.headerOffset
  }

  private static func initializeContentPageViewController() -> IMainScreenContentView {
    let context = CoreDataStack.shared.backgroundContext // TODO: mmk edit
    let eventsFetchRequest = Event.fetchRequestWithSorting(descriptors: [
      NSSortDescriptor(keyPath: \Event.nextEventDate, ascending: true)
    ])
    let eventsService = EventsCoreDataService(context: context, fetchRequest: eventsFetchRequest)

    let contentView = MainScreenContentModuleBuilder.build(eventsService: eventsService)

    return contentView
  }

}

import SwiftUI


#Preview {
  MainScreenViewController().makePreview()
}
