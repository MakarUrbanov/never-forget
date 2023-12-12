//
//  EventScreenViewController.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 29.09.2023
//

import SwiftDate
import UIKit

class EventScreenViewController: UIViewController {

  var presenter: IEventScreenPresenterInput

  private lazy var scrollView = UIScrollView()
  private lazy var contentView = UIView()
  private lazy var saveButton = TouchableButton()

  private lazy var contentStackView = UIStackView()
  private lazy var originDatePickerButton = TitledButton()

  private lazy var notificationRulesView: INotificationRulesView = NotificationRulesModuleBuilder.build(
    event: presenter.getEvent(),
    saveNewNotificationsRuleType: { [weak self] ruleType in
      self?.presenter.didSetNewNotificationsRuleType(ruleType)
    }
  )

  init(presenter: IEventScreenPresenterInput) {
    self.presenter = presenter

    super.init(nibName: nil, bundle: nil)

    notificationRulesView.parentViewController = self
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor(resource: .darkBackground)

    setupUI()

    presenter.viewDidLoad()
  }

}

// MARK: - IEventScreenPresenterOutput
extension EventScreenViewController: IEventScreenPresenterOutput {

  func setOriginDate(_ date: Date) {
    let formattedDate = date.convertTo(region: .local).formatterForRegion(format: "dd MMMM yyyy").string(from: date)

    originDatePickerButton.setText(formattedDate)
  }

  func openDatePicker() {
    let datePicker = EventDatePickerViewController()
    datePicker.setSelectedDate(presenter.getOriginDate())

    datePicker.setOnCancel { [weak datePicker] in
      datePicker?.dismiss(animated: true)
    }
    datePicker.setOnSave { [weak datePicker, weak self] in
      if let newDate = datePicker?.selectedDate {
        self?.presenter.didChangeOriginDate(newDate)
      }
      datePicker?.dismiss(animated: true)
    }

    presentBottomSheet(datePicker, detents: [.contentSize])
  }

  func openNotificationsTypeSelector() {
    // TODO: mmk impl
  }

}

// MARK: - Private
private extension EventScreenViewController {}

// MARK: - Setup UI
private extension EventScreenViewController {

  private func setupUI() {
    configureDatePicker()

    setupNavigationBar()
    setupSaveButton()
    setupScrollView()
    setupContentView()
    setupContentStackView()
  }

  private func configureDatePicker() {}

  private func setupNavigationBar() {
    navigationItem.title = String(localized: "Birthday")
    isModalInPresentation = true

    let arrowLeft = UIImage(systemName: "arrow.left")?.withTintColor(
      UIColor(resource: .textLight100).withAlphaComponent(0.3),
      renderingMode: .alwaysOriginal
    )
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      title: "",
      image: arrowLeft,
      primaryAction: UIAction(handler: { [weak self] _ in
        self?.presenter.goBack()
      })
    )
  }

  private func setupSaveButton() {
    saveButton.setTitle(String(localized: "Save"), for: .normal)
    saveButton.makePrimaryButton()

    let saveButtonAction = UIAction { [weak self] _ in
      self?.presenter.didPressSaveEventButton()
    }
    saveButton.addAction(saveButtonAction, for: .primaryActionTriggered)

    view.addSubview(saveButton)

    saveButton.snp.makeConstraints { make in
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
      make.horizontalEdges.equalToSuperview().inset(UIConstants.verticalInset)
      make.height.equalTo(44)
    }
  }

  private func setupScrollView() {
    scrollView.alwaysBounceVertical = true
    scrollView.showsVerticalScrollIndicator = false
    scrollView.keyboardDismissMode = .onDrag
    scrollView.isDirectionalLockEnabled = true

    view.addSubview(scrollView)

    scrollView.snp.makeConstraints { make in
      make.horizontalEdges.equalToSuperview().inset(UIConstants.verticalInset)
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.bottom.equalTo(saveButton.snp.top).offset(-4)
    }
  }

  private func setupContentView() {
    scrollView.addSubview(contentView)

    contentView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
      make.width.equalToSuperview()
    }
  }

  private func setupContentStackView() {
    contentStackView.axis = .vertical
    contentStackView.distribution = .fillEqually
    contentStackView.spacing = UIConstants.spacingAmongFields

    contentView.addSubview(contentStackView)

    contentStackView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(UIConstants.spacingAmongFields)
      make.width.horizontalEdges.equalToSuperview()
      make.bottom.equalToSuperview().inset(40)
    }

    setupDatePicker()
    setupNotificationRulesView()
  }

  private func setupDatePicker() {
    originDatePickerButton.button.configuration?.baseForegroundColor = UIColor(resource: .textLight100)
    originDatePickerButton.button.configuration?.titleTextAttributesTransformer = .init {
      $0.merging(.init([
        .font: UIFont.systemFont(ofSize: 14, weight: .regular),
      ]))
    }

    originDatePickerButton.isRequiredField = true
    originDatePickerButton.setTitle(String(localized: "Date"))

    let openDatePickerAction = UIAction { [weak self] _ in
      self?.presenter.didPressOpenDatePicker()
    }
    originDatePickerButton.button.addAction(openDatePickerAction, for: .primaryActionTriggered)

    contentStackView.addArrangedSubview(originDatePickerButton)

    originDatePickerButton.snp.makeConstraints { make in
      make.width.equalToSuperview()
      make.height.equalTo(UIConstants.fieldHeight)
    }
  }

  private func setupNotificationRulesView() {
    contentStackView.addArrangedSubview(notificationRulesView)

    notificationRulesView.snp.makeConstraints { make in
      make.width.equalToSuperview()
      make.height.greaterThanOrEqualTo(UIConstants.fieldHeight)
      make.bottom.equalTo(notificationRulesView.snp.bottom)
    }
  }

}

// MARK: - Static
extension EventScreenViewController {

  enum UIConstants {
    static let verticalInset: CGFloat = 16
    static let spacingAmongFields: CGFloat = 20
    static let fieldHeight: CGFloat = 72
  }

}
