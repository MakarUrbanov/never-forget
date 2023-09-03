//
//  UnfairLock.swift
//  NeverForgetApp
//
//  Created by makar on 4/1/23.
//

import Foundation

final class UnfairLock {
  private var _lock: UnsafeMutablePointer<os_unfair_lock>

  init() {
    _lock = UnsafeMutablePointer<os_unfair_lock>.allocate(capacity: 1)
    _lock.initialize(to: os_unfair_lock())
  }

  func locked<ReturnValue>(_ callback: () throws -> ReturnValue) rethrows -> ReturnValue {
    os_unfair_lock_lock(_lock)
    defer { os_unfair_lock_unlock(_lock) }
    return try callback()
  }

  deinit {
    _lock.deallocate()
  }

}
