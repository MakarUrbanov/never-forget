//
//  Bindable.swift
//  NeverForgetApp
//
//  Created by makar on 5/18/23.
//

import Foundation

final class Bindable<Value> {
  typealias Listener = (Value) -> Void

  private var listener: Listener?
  var value: Value {
    didSet { listener?(value) }
  }

  init(_ value: Value) {
    self.value = value
  }

  func bind(_ listener: Listener?) {
    self.listener = listener
  }
}
