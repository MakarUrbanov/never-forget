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


// MARK: - IPageControllerHeaderViewDelegate
extension NewMainScreenViewController: IViewsSwitcherViewDelegate {

  func viewsSwitcher(_ switcher: IViewsSwitcherView, didSelect button: SwitcherButtonData) {
    // TODO: mmk hardcode
    if button.index == 0 {
      let viewController = contentPageViewController.viewControllersList[1] // TODO: mmk find out why wrong indexes
      contentPageViewController.setViewControllers([viewController], direction: .reverse, animated: true)
    } else {
      let viewController = contentPageViewController.viewControllersList[0]
      contentPageViewController.setViewControllers([viewController], direction: .forward, animated: true)
    }
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
    guard let previousViewController = previousViewControllers.first, completed else { return }

    // TODO: mmk hardcode
    if contentPageViewController.viewControllersList[0] == previousViewController {
      let button = pageHeader.pageSwitcher.buttons[0]
      pageHeader.pageSwitcher.select(button: button)
    } else {
      let button = pageHeader.pageSwitcher.buttons[1]
      pageHeader.pageSwitcher.select(button: button)
    }
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

    let rightBarItem = UIBarButtonItem(customView: NotificationHeaderButton(withBadge: true))
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

    addChild(contentPageViewController)
    view.addSubview(contentPageViewController.view)
    contentPageViewController.didMove(toParent: self)

    contentPageViewController.view.snp.makeConstraints { make in
      make.top.equalTo(pageHeader.snp.bottom)
      make.left.right.bottom.equalToSuperview()
    }
  }

}


// TODO; mmk move
// MARK: - That should be moved


// MARK: - Header items
extension NewMainScreenViewController {

  class TodayDateView: UIStackView {

    private static let todayDate = Date.now
    private static let todayDateFormat = "EE, dd MMMM"

    let dateTitle: UILabel = {
      let label = UILabel()
      label.text = TodayDateView.todayDate.toFormat(TodayDateView.todayDateFormat)
      label.textColor = UIColor(resource: .textLight100)
      label.font = UIFont.systemFont(.title3, .regular)

      return label
    }()

    let yearTitle: UILabel = {
      let label = UILabel()
      label.text = TodayDateView.todayDate.toFormat("YYYY")
      label.textColor = UIColor(resource: .textLight30)
      label.font = UIFont.systemFont(.title3, .regular)

      return label
    }()

    required init() {
      super.init(frame: .zero)

      axis = .horizontal
      distribution = .fill
      spacing = 8

      initialize()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    private func initialize() {
      addDateTitle()
      addYearTitle()
    }

    private func addDateTitle() {
      addArrangedSubview(dateTitle)
    }

    private func addYearTitle() {
      addArrangedSubview(yearTitle)
    }
  }

  // MARK: - NotificationHeaderButton
  private class NotificationHeaderButton: UIButton {

    private(set) var withBadge: Bool

    private let badge = UIView()

    required init(withBadge: Bool) {
      self.withBadge = withBadge
      super.init(frame: .zero)

      setImage()
      setWithBadge(withBadge)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    func setWithBadge(_ withBadge: Bool) {
      self.withBadge = withBadge
      if withBadge {
        setBadge()
      } else {
        removeBadge()
      }
    }

    private func setImage() {
      setImage(UIImage(systemName: "bell.fill"), for: .normal)
      imageView?.tintColor = UIColor(resource: .textLight100)
    }

    private func setBadge() {
      badge.backgroundColor = UIColor(resource: .main100)
      badge.layer.cornerRadius = 3

      addSubview(badge)

      badge.snp.makeConstraints { make in
        make.width.height.equalTo(6)
        make.top.trailing.equalToSuperview()
      }
    }

    private func removeBadge() {
      badge.removeFromSuperview()
    }
  }

}

import SwiftUI


#Preview {
  NewMainScreenViewController(viewModel: NewMainScreenViewModel()).makePreview()
}
