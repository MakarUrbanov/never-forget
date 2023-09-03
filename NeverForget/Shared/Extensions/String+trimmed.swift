//
//  String+trimmed.swift
//  never-forget
//
//  Created by makar on 2/24/23.
//

import Foundation

extension String {

  func trim() -> String {
    trimmingCharacters(in: .whitespacesAndNewlines)
  }

}
