//
//  NotificationRulesView.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 10.10.2023
//

import UIKit

protocol INotificationRulesView: UIView {
  var parentViewController: UIViewController? { get set }
}

class NotificationRulesView: UIView, INotificationRulesView {

  // MARK: - Public vars
  weak var parentViewController: UIViewController?

  // MARK: - Private vars
  private let viewModel: INotificationRulesViewModel

  // MARK: - UI
  private lazy var titleButton: ITitledButton = TitledButton()
  private lazy var timesTableView: INotificationTimesTableView = NotificationTimesTableView(
    viewModel: NotificationTimesTableViewModel(event: viewModel.event)
  )

  // MARK: - Init
  init(viewModel: INotificationRulesViewModel) {
    self.viewModel = viewModel

    super.init(frame: .zero)

    setupBindings()
    setupUI()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

// MARK: - Private methods
private extension NotificationRulesView {

  private func setupBindings() {
    viewModel.notificationsSchedulingRule.bind { [weak self] rule in
      let newRuleTitle = NotificationTextByType.get(rule)
      self?.titleButton.setText(newRuleTitle)

      self?.updateNotificationTimesVisibility(by: rule)
    }
  }

  private func dismissFromParentViewController() {
    parentViewController?.dismiss(animated: true)
  }

  private func didPressCancelNotificationsType() {
    dismissFromParentViewController()
  }

}

// MARK: - Notifications Rule changing methods
private extension NotificationRulesView {

  private func updateNotificationTimesVisibility(by newRule: Event.NotificationsSchedulingRule) {
    if newRule == .customSettings {
      setupTimesTableView()
    } else {
      timesTableView.removeFromSuperview()
    }
  }

  private func didPressSaveNotificationsType(newRule: Event.NotificationsSchedulingRule) {
    viewModel.didPressSaveNewRule(newRule)
    dismissFromParentViewController()
  }

  private func openNotificationsTypePicker() {
    let notificationsTypeView = NotificationsTypeSelectorView(initialType: viewModel.notificationsSchedulingRule.value)
    notificationsTypeView.setOnSave { [weak self] newRule in
      self?.didPressSaveNotificationsType(newRule: newRule)
    }
    notificationsTypeView.setOnCancel { [weak self] in
      self?.didPressCancelNotificationsType()
    }

    parentViewController?.presentBottomSheet(notificationsTypeView, detents: [.contentSize])
  }

}

// MARK: - Setup UI
private extension NotificationRulesView {

  private func setupUI() {
    setupNotificationRuleMenu()
    setupTimesTableView()
  }

  private func setupNotificationRuleMenu() {
    titleButton.isRequiredField = true
    titleButton.setTitle(String(localized: "Notifications"))
    let initialText = NotificationTextByType.get(viewModel.notificationsSchedulingRule.value)
    titleButton.setText(initialText)
    titleButton.button.addAction(.init(handler: { [weak self] _ in
      self?.openNotificationsTypePicker()
    }), for: .primaryActionTriggered)

    titleButton.button.configuration?.baseForegroundColor = UIColor(resource: .textLight100)
    titleButton.button.configuration?.titleTextAttributesTransformer = .init {
      $0.merging(.init([
        .font: UIFont.systemFont(ofSize: 14, weight: .regular),
      ]))
    }

    addSubview(titleButton)

    titleButton.snp.makeConstraints { make in
      make.leading.top.trailing.width.equalToSuperview()
      make.height.equalTo(UIConstants.fieldHeight)
    }
  }

  private func setupTimesTableView() {
    let rule = viewModel.notificationsSchedulingRule.value

    if rule != .customSettings {
      return
    }

    addSubview(timesTableView)

    timesTableView.snp.makeConstraints { make in
      make.top.equalTo(titleButton.snp.bottom).offset(UIConstants.offsetAmongFields)
      make.horizontalEdges.equalToSuperview()
      make.bottom.equalToSuperview()
    }
  }

}

// MARK: - Static
extension NotificationRulesView {

  private enum UIConstants {
    static let fieldHeight: CGFloat = 72
    static let offsetAmongFields: CGFloat = 12
    static let tableViewCellHeight: CGFloat = 44
  }

}
