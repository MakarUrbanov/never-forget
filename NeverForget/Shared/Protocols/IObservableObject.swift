//
//  IObservableObject.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 18.09.2023.
//

import Foundation

protocol IObservableObject: AnyObject {
  var notificationName: NSNotification.Name { get }

  func addObserver(target: Any, selector: Selector)
  func removeObserver(from target: Any)
}
