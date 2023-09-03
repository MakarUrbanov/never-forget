//
//  String+uppercasedFirst.swift
//  NeverForgetApp
//
//  Created by makar on 3/31/23.
//

import Foundation

extension String {

  func capitalizeFirst() -> String {
    let firstLetter = prefix(1).capitalized
    let remainingLetters = dropFirst()
    return firstLetter + remainingLetters
  }

}
