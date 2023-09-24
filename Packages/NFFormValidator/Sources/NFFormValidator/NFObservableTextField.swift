//
//  NFObservableTextField.swift
//
//
//  Created by Makar Mishchenko on 24.09.2023.
//

import UIKit

public class NFObservableTextField: INFObservableField {

  // MARK: - Public properties
  public var isValid = true
  public var isValidating: Bool = false

  // MARK: - Private properties
  private weak var textField: UITextField?

  private var validateCallback: ValidationCallback?
  private var onValidCallback: OnValidCallback?
  private var onInvalidCallback: OnInvalidCallback?

  // MARK: - Init
  public init(textField: UITextField) {
    self.textField = textField
  }

  // MARK: - Public methods
  public func setupOnValid(_ onValidCallback: @escaping OnValidCallback) -> Self {
    self.onValidCallback = onValidCallback
    return self
  }

  public func setupOnInvalid(_ onInvalidCallback: @escaping OnInvalidCallback) -> Self {
    self.onInvalidCallback = onInvalidCallback
    return self
  }

  public func setupValidation(_ validationCallback: @escaping ValidationCallback) -> Self {
    validateCallback = validationCallback

    textField?.addTarget(self, action: #selector(valueDidChange), for: .editingChanged)

    return self
  }

  public func validate() {
    guard let textField else { return }

    valueDidChange(textField)
  }

}

// MARK: - Private methods
private extension NFObservableTextField {

  @objc
  private func valueDidChange(_ sender: UITextField) {
    guard isValidating, let validateCallback else { return }

    let text = sender.text
    let (newIsValid, errorMessage) = validateCallback(text)

    if isValid == newIsValid { return }

    isValid = newIsValid

    if newIsValid {
      onValidCallback?()
    } else {
      onInvalidCallback?(errorMessage)
    }
  }

}

// MARK: - Static
public extension NFObservableTextField {

  typealias ValidationCallback = (String?) -> (isValid: Bool, error: String?)
  typealias OnValidCallback = () -> Void
  typealias OnInvalidCallback = (_ errorMessage: String?) -> Void

}
