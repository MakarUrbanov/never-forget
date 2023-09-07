//
//  Observable.swift
//
//
//  Created by Makar Mishchenko on 06.09.2023.
//

import Foundation

public class Observable<T> {
  // MARK: - Public properties
  public var valueChanged: ((T) -> Void)?
  public var value: T { didSet { valueChanged?(value) } }

  // MARK: - Init
  public init(_ value: T) {
    self.value = value
  }

  public init(_ value: T, valueChanged: @escaping (T) -> Void) {
    self.value = value
    valueChanged(value)
    self.valueChanged = valueChanged
  }

  // MARK: - Public methods
  public func bind(_ closure: @escaping (T) -> Void) {
    closure(value)
    valueChanged = closure
  }
}
