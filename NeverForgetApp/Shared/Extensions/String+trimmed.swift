//
//  String+trimmed.swift
//  never-forget
//
//  Created by makar on 2/24/23.
//

import Foundation

extension String {

  var trimmed: String {
    trimmingCharacters(in: .whitespacesAndNewlines)
  }

}
