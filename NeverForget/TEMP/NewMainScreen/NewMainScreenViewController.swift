//
//  NewMainScreenViewController.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 08.09.2023.
//

import NFCore
import SwiftDate
import UIKit

// MARK: - Protocol
protocol INewMainScreenViewController: UIViewController {
  var viewModel: INewMainScreenViewModel { get }
  var pageHeader: IMainScreenHeaderView { get }
  var contentPageViewController: INewMainScreenContentPageViewController { get }
}

// MARK: - NewMainScreenViewController
final class NewMainScreenViewController: UIViewController, INewMainScreenViewController {

  // MARK: - Public properties
  var viewModel: INewMainScreenViewModel
  let pageHeader: IMainScreenHeaderView = MainScreenHeaderView()
  lazy var contentPageViewController: INewMainScreenContentPageViewController = NewMainScreenContentPageViewController(
    transitionStyle: .scroll,
    navigationOrientation: .horizontal
  )

  // MARK: - Init
  init(viewModel: INewMainScreenViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Public methods
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor(resource: .darkBackground)

    initialize()
  }

}

// MARK: - UIScrollViewDelegate
extension NewMainScreenViewController: UIScrollViewDelegate {
  // TODO: mmk finish logic
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let currentSelectedViewIndex = CGFloat(pageHeader.pageSwitcher.currentSelectedButtonIndex)
    let pageOffset = scrollView.contentOffset.x / scrollView.frame.width - 1 + currentSelectedViewIndex
    let buttonsCount = CGFloat(pageHeader.pageSwitcher.buttons.count)
    let lastButtonIndex = buttonsCount - 1
    let correctPageOffset = pageOffset < 0 ? 0 : pageOffset > lastButtonIndex ? lastButtonIndex : pageOffset

    pageHeader.pageSwitcher.setSelectAnimated(correctPageOffset)
  }
}

// MARK: - UIPageViewControllerDelegate
extension NewMainScreenViewController: UIPageViewControllerDelegate {

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
      let newViewControllerIndex = contentPageViewController.viewControllersList.firstIndex(of: currentViewController)
    else {
      return
    }

    let button = pageHeader.pageSwitcher.buttons[newViewControllerIndex]
    pageHeader.pageSwitcher.select(button: button)
  }

}

// MARK: - IPageControllerHeaderViewDelegate
extension NewMainScreenViewController: IViewsSwitcherViewDelegate {

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

// MARK: - Static
extension NewMainScreenViewController {

  enum UIConstants {
    static let pageHorizontalInset = 16
    static let headerOffset = 20
    static let pageHeaderHeight = 60
    static let dividerHeight = UIConstants.headerOffset
  }

}

// MARK: - Private methods
private extension NewMainScreenViewController {

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
      make.left.right.bottom.equalToSuperview()
    }
  }

  private func setupPageScrollViewSettings() {
    contentPageViewController.scrollView?.delegate = self
  }

}


import SwiftUI


#Preview {
  NewMainScreenViewController(viewModel: NewMainScreenViewModel()).makePreview()
}