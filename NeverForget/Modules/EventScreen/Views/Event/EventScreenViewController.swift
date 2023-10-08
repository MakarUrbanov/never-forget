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

  private lazy var datePicker: IEventDatePicker = EventDatePicker(interval: .init(start: .distantPast, end: .now))

  private lazy var scrollView = UIScrollView()
  private lazy var contentView = UIView()
  private lazy var saveButton = UIButton()

  private lazy var contentStackView = UIStackView()
  private lazy var originDatePickerButton = TitledButton()

  init(presenter: IEventScreenPresenterInput) {
    self.presenter = presenter
    super.init(nibName: nil, bundle: nil)
  }

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

}

// MARK: - Private
private extension EventScreenViewController {

  private func showDatePicker(from sender: UIView) {
    if let popoverController = datePicker.popoverPresentationController {
      popoverController.sourceView = sender
      popoverController.sourceRect = .init(origin: .init(x: sender.bounds.midX, y: sender.bounds.maxY + 4), size: .zero)
      popoverController.permittedArrowDirections = [.up]
      popoverController.delegate = self
    }

    let originDate = presenter.getOriginDate()
    datePicker.setDate(date: originDate)

    present(datePicker, animated: true)
  }

  @objc
  private func didPressSaveEventButton(_ sender: UIButton) {
    // TODO: mmk implement
  }

  @objc
  private func didPressOpenDatePicker(_ sender: UIButton) {
    showDatePicker(from: sender)
  }
}

// MARK: - UIPopoverPresentationControllerDelegate
extension EventScreenViewController: UIPopoverPresentationControllerDelegate {

  func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
    .none
  }

}

// MARK: - IEventDatePickerDelegate
extension EventScreenViewController: IEventDatePickerDelegate {

  func didChangeDate(datePicker: IEventDatePicker, date: Date) {
    presenter.didChangeOriginDate(date)
  }

}

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

  private func configureDatePicker() {
    datePicker.delegate = self
    datePicker.modalPresentationStyle = .popover

    let datePickerWidth = view.bounds.width * 0.8
    let datePickerHeight = datePickerWidth * 1.1
    datePicker.preferredContentSize = .init(width: datePickerWidth, height: datePickerHeight)
  }

  private func setupNavigationBar() {
    navigationItem.title = String(localized: "Adding an event")
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

    saveButton.addTarget(self, action: #selector(didPressSaveEventButton), for: .touchUpInside)

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
      make.top.equalToSuperview()
      make.width.horizontalEdges.equalToSuperview()
      make.bottom.equalToSuperview().inset(40)
    }

    setupDatePicker()
  }

  private func setupDatePicker() {
    originDatePickerButton.button.configuration?.baseForegroundColor = UIColor(resource: .textLight100)
    originDatePickerButton.button.configuration?.titleTextAttributesTransformer = .init({
      $0.merging(.init([
        .font: UIFont.systemFont(ofSize: 14, weight: .regular)
      ]))
    })

    originDatePickerButton.isRequiredField = true
    originDatePickerButton.setTitle(String(localized: "Date"))
    originDatePickerButton.button.addTarget(self, action: #selector(didPressOpenDatePicker), for: .touchUpInside)

    contentStackView.addArrangedSubview(originDatePickerButton)

    contentStackView.snp.makeConstraints { make in
      make.width.equalToSuperview()
      make.height.equalTo(72)
    }
  }

}

// MARK: - Static
extension EventScreenViewController {

  enum UIConstants {
    static let verticalInset: CGFloat = 16
    static let spacingAmongFields: CGFloat = 20
  }

}
