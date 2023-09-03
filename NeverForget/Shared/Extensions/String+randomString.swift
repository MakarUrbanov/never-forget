//
//  String+randomString.swift
//  never-forget
//
//  Created by makar on 3/5/23.
//

import Foundation

extension String {

  static func randomString(length: Int) -> String {
    return String((0..<length).map { _ in String.getRandomLetter() })
  }

  static func randomString(maxLength: Int, numberOfWords: Int) -> String {
    switch true {
      case numberOfWords < 1 || maxLength < 1:
        fatalError("arguments value must be more than 1")
      case (Double(maxLength) / Double(numberOfWords)) <= 2:
        fatalError("maxLength must be twice numberOfWords")
      default:
        break
    }

    return Array(repeating: "", count: numberOfWords).map { _ in
      Array(repeating: String(""), count: Int.random(in: 1...maxLength)).map { _ in
        String(String.getRandomLetter())
      }.joined()
    }.joined(separator: " ")
  }

}

// MARK: - utils & constants

extension String {

  private static let ALL_LETTERS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

  private static func getRandomLetter() -> Character { String.ALL_LETTERS.randomElement() ?? Character("a") }

}
