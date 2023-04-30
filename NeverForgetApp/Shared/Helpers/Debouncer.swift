//
//  Debouncer.swift
//  NeverForgetApp
//
//  Created by makar on 4/30/23.
//

import Foundation

final class Debouncer: ObservableObject {

  private var timer: Timer?
  private let delay: TimeInterval

  init(delay: TimeInterval) {
    self.delay = delay
  }

  func perform(action: @escaping () -> Void) {
    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
      action()
    }
  }
}
