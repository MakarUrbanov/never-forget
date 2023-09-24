//
//  INFObservableField.swift
//
//
//  Created by Makar Mishchenko on 24.09.2023.
//

import Foundation

public protocol INFObservableField: AnyObject {
  var isValid: Bool { get }
  var isValidating: Bool { get set }

  func setupOnValid(_ onValidCallback: @escaping () -> Void) -> Self
  func setupOnInvalid(_ onInvalidCallback: @escaping (_ errorMessage: String?) -> Void) -> Self

  func validate()
}
