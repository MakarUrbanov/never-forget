//
//  INFCalendarDelegate.swift
//
//
//  Created by Makar Mishchenko on 14.08.2023.
//

import UIKit

// MARK: - Protocol
public protocol INFCalendarDelegate: AnyObject {
  func calendar(_ calendar: NFCalendarView, didSelect date: Date)
}

// MARK: - Making the optional methods
public extension INFCalendarDelegate {}
