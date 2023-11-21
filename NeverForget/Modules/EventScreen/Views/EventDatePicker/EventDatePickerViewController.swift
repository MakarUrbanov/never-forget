//
//  EventDatePickerViewController.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 21.11.2023.
//

import SnapKit
import UIKit

protocol IEventDatePickerViewController: UIViewController {
  var selectedDate: Date? { get }
  func setOnSave(_ onSave: @escaping () -> Void)
  func setOnCancel(_ onCancel: @escaping () -> Void)
  func setSelectedDate(_ date: Date)
}

class EventDatePickerViewController: UIViewController, IEventDatePickerViewController {

  var selectedDate: Date?

  private lazy var cancelSaveButtons: ICancelSaveButtonsView = CancelSaveButtonsView()
  private lazy var datePicker: IDatePickerSingleSelection = DatePickerSingleSelection(
    availableDateRange: Constants.datePickerDateRange
  )

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor(resource: .darkBackground)
    setupUI()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    recomputeContentSize()
  }

  func setOnSave(_ onSave: @escaping () -> Void) {
    cancelSaveButtons.onSave = onSave
  }

  func setOnCancel(_ onCancel: @escaping () -> Void) {
    cancelSaveButtons.onCancel = onCancel
  }

  func setSelectedDate(_ date: Date) {
    selectedDate = date
    datePicker.setDate(date: date)
  }

}

// MARK: - Private
private extension EventDatePickerViewController {

  private func recomputeContentSize() {
    let height = datePicker.bounds.height + cancelSaveButtons.bounds.height + Constants.spacing * 2
    preferredContentSize = .init(width: preferredContentSize.width, height: height)
  }

}

// MARK: - Setup UI
extension EventDatePickerViewController {

  private func setupUI() {
    setupDatePicker()
    setupCancelSaveButtons()
  }

  private func setupDatePicker() {
    datePicker.delegate = self
    datePicker.tintColor = UIColor(resource: .main100)

    view.addSubview(datePicker)

    datePicker.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.spacing)
      make.leading.trailing.equalToSuperview().inset(Constants.spacing)
      make.bottom.equalTo(datePicker.snp.bottom)
    }
  }

  private func setupCancelSaveButtons() {
    cancelSaveButtons.layer.zPosition = 2
    view.addSubview(cancelSaveButtons)

    cancelSaveButtons.snp.makeConstraints { make in
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
      make.leading.trailing.equalToSuperview().inset(Constants.spacing)
      make.height.equalTo(Constants.buttonsHeight)
    }
  }

}

extension EventDatePickerViewController: IDatePickerSingleSelectionDelegate {

  func didChangeDate(datePicker: IDatePickerSingleSelection, date: Date) {
    selectedDate = date
  }

}

// MARK: - Static
extension EventDatePickerViewController {

  enum Constants {
    static let datePickerDateRange = DateInterval(start: .distantPast, end: .now)
    static let spacing: CGFloat = 24
    static let buttonsHeight = 44
  }

}

// MARK: - Preview
import SwiftUI

#Preview {
  let viewController = EventDatePickerViewController()
  return viewController.makePreview()
}
