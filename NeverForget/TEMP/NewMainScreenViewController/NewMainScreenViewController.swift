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
  var contentPageViewController: INewMainScreenContentPageViewController { get }

}

// MARK: - NewMainScreenViewController
final class NewMainScreenViewController: UIViewController, INewMainScreenViewController {

  private let pageHeader = PageControllerHeaderView()
  lazy var contentPageViewController: INewMainScreenContentPageViewController = NewMainScreenContentPageViewController(
    transitionStyle: .scroll,
    navigationOrientation: .horizontal
  )

  override func viewDidLoad() {
    super.viewDidLoad()

    initialize()
  }

}

// MARK: - Private methods
extension NewMainScreenViewController {

  private func initialize() {
    view.backgroundColor = UIColor(resource: .darkBackground)

    initializeNavigationHeader()
    initializePageHeader()
    initializeContentPageViewController()
  }

}

// MARK: - Private methods
extension NewMainScreenViewController {

  enum UIConstants {
    static let headerOffset = 40
  }

  private func initializeNavigationHeader() {
    let leftBarItem = UIBarButtonItem(customView: TodayDateView())
    navigationItem.setLeftBarButton(leftBarItem, animated: false)

    let rightBarItem = UIBarButtonItem(customView: NotificationHeaderButton(withBadge: true))
    navigationItem.setRightBarButton(rightBarItem, animated: false)
  }

  private func initializePageHeader() {
    pageHeader.delegate = self

    view.addSubview(pageHeader)

    pageHeader.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.width.equalToSuperview().inset(16)
      make.height.equalTo(40)
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(UIConstants.headerOffset / 2)
    }
  }

  private func initializeContentPageViewController() {
    contentPageViewController.delegate = self

    addChild(contentPageViewController)
    view.addSubview(contentPageViewController.view)
    contentPageViewController.didMove(toParent: self)

    contentPageViewController.view.snp.makeConstraints { make in
      make.top.equalTo(pageHeader.snp.bottom).offset(UIConstants.headerOffset / 2) // TODO: mmk / 2 is temp
      make.left.right.bottom.equalToSuperview()
    }
  }

}

extension NewMainScreenViewController: IPageControllerHeaderViewDelegate {
  func pageControllerHeaderView(_ pageController: IPageControllerHeaderView, didSelect button: SwitcherButtonData) {
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


// TODO; mmk move
// MARK: - That should be moved


// MARK: - NewMainScreenViewController
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

// MARK: - Header switcher protocols
protocol IPageControllerHeaderViewDelegate: AnyObject {
  func pageControllerHeaderView(_ pageController: IPageControllerHeaderView, didSelect button: SwitcherButtonData)
}

protocol IPageControllerHeaderView: UIStackView {
  var pageSwitcher: IViewsSwitcherView { get }
  var sortButton: UIButton { get }
  var delegate: IPageControllerHeaderViewDelegate? { get set }
}

// MARK: - Header switcher
class PageControllerHeaderView: UIStackView, IPageControllerHeaderView {

  let pageSwitcher: IViewsSwitcherView = ViewsSwitcherView(buttons: [
    .init(text: String(localized: "Calendar"), index: 0),
    .init(text: String(localized: "List"), index: 1)
  ])

  // TODO: mmk доделать
  let sortButton = UIButton(frame: .zero)

  weak var delegate: IPageControllerHeaderViewDelegate?

  init() {
    super.init(frame: .zero)

    axis = .horizontal
    alignment = .fill
    spacing = 8
    distribution = .fillProportionally
    layer.masksToBounds = true

    initializePageSwitcher()
    initializeSortButton()
  }

  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func initializePageSwitcher() {
    pageSwitcher.layer.cornerRadius = 12
    pageSwitcher.backgroundColor = UIColor(resource: .textLight100).withAlphaComponent(0.08)

    pageSwitcher.delegate = self

    addArrangedSubview(pageSwitcher)

    pageSwitcher.snp.makeConstraints { make in
      make.height.equalToSuperview()
    }
  }

  private func initializeSortButton() {
    sortButton.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle"), for: .normal)
    sortButton.imageView?.tintColor = UIColor(resource: .textLight100)

    sortButton.backgroundColor = UIColor(resource: .textLight100).withAlphaComponent(0.08)
    sortButton.layer.cornerRadius = 12

    addArrangedSubview(sortButton)

    sortButton.snp.makeConstraints { make in
      make.height.equalToSuperview()
      make.width.height.equalTo(40)
    }
  }
}

extension PageControllerHeaderView: IViewsSwitcherViewDelegate {

  func viewsSwitcher(_ switcher: IViewsSwitcherView, didSelect button: SwitcherButtonData) {
    delegate?.pageControllerHeaderView(self, didSelect: button)
  }

}


import SwiftUI


#Preview {
  NewMainScreenViewController().makePreview()
}
