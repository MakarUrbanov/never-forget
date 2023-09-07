//
//  NewMainScreenViewController.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 08.09.2023.
//

import SwiftDate
import UIKit

final class NewMainScreenViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    initialize()
  }

}

// MARK: - Private methods
extension NewMainScreenViewController {

  private func initialize() {
    view.backgroundColor = UIColor.Theme.darkBackground

    initializeHeader()

    let button = UIButton()
    button.setTitle("Press", for: .normal)
    button.addTarget(self, action: #selector(didPressed), for: .touchUpInside)

    view.addSubview(button)

    button.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }

  @objc
  private func didPressed() {
    let viewController = UIViewController()
    viewController.view.backgroundColor = .blue
    navigationController?.pushViewController(viewController, animated: true)
  }

}

// MARK: - Header
extension NewMainScreenViewController {

  private func initializeHeader() {
    let leftBarItem = UIBarButtonItem(customView: TodayDateView())
    navigationItem.setLeftBarButton(leftBarItem, animated: false)

    let rightBarItem = UIBarButtonItem(customView: NotificationHeaderButton(withBadge: true))
    navigationItem.setRightBarButton(rightBarItem, animated: false)
  }

}


// MARK: - That should be moved


// MARK: - NewMainScreenViewController
extension NewMainScreenViewController {

  class TodayDateView: UIStackView {

    private static let todayDate = Date.now
    private static let todayDateFormat = "EE, dd MMMM"

    let dateTitle: UILabel = {
      let label = UILabel()
      label.text = TodayDateView.todayDate.toFormat(TodayDateView.todayDateFormat)
      label.textColor = UIColor.Theme.textLight100
      label.font = UIFont.systemFont(.title3, .regular)

      return label
    }()

    let yearTitle: UILabel = {
      let label = UILabel()
      label.text = TodayDateView.todayDate.toFormat("YYYY")
      label.textColor = UIColor.Theme.textLight30
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
