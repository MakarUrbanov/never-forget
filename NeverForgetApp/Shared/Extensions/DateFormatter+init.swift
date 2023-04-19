//
//  DateFormatter+init.swift
//  NeverForgetApp
//
//  Created by makar on 3/31/23.
//

import Foundation

extension DateFormatter {

  convenience init(dateFormat: String) {
    self.init()
    self.dateFormat = dateFormat
  }

}
