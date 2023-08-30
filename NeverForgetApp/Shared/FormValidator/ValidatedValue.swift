//
//  ValidatedValue.swift
//  never-forget
//
//  Created by makar on 3/12/23.
//

import Foundation

struct ValidatedValue<Value> {
  struct ValidatorResult {
    var isValid: Bool
    var errorMessage: String?
  }

  var value: Value { didSet { valueDidSet() } }
  private(set) var isValid: Bool
  private(set) var errorMessage: String?
  private(set) var isVisibleError: Bool
  private let validate: (Value) -> ValidatorResult

  init(
    value: Value,
    initialIsValid: Bool = false,
    isVisibleError: Bool = false,
    isValidateOnInit: Bool = false,
    validate: @escaping (Value) -> ValidatorResult
  ) {
    self.value = value
    self.validate = validate
    isValid = initialIsValid
    self.isVisibleError = isVisibleError

    if isValidateOnInit {
      let result = validate(value)
      isValid = result.isValid
      errorMessage = result.errorMessage
    }
  }

  mutating func editErrorVisibility(_ isVisible: Bool) {
    isVisibleError = isVisible
  }

  private mutating func valueDidSet() {
    let result = validate(value)
    isValid = result.isValid
    errorMessage = result.errorMessage
  }

}
