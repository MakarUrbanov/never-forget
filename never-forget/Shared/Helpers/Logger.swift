//
//  Logger.swift
//  never-forget
//
//  Created by makar on 3/24/23.
//

import Foundation

enum Logger {

  static func error(prefix: String? = nil, _ values: Any...) {
    let correctPrefix = getPrefix(case: "ERROR 🔴", usersPrefix: prefix)
    toPrint(with: correctPrefix, values)
  }

  static func warn(prefix: String? = nil, _ values: Any...) {
    let correctPrefix = getPrefix(case: "WARN 🟠", usersPrefix: prefix)
    toPrint(with: correctPrefix, values)
  }

  static func info(prefix: String? = nil, _ values: Any...) {
    let correctPrefix = getPrefix(case: "INFO 🔵", usersPrefix: prefix)
    toPrint(with: correctPrefix, values)
  }

}

// MARK: - Output

extension Logger {

  private static func myDump(name: String, _ values: Any...) {
    dump(values, name: name)
  }

  private static func myPrint(name: String, _ output: String) {
    print("\(name) \(output)")
  }

  private static func toPrint(with name: String, _ values: Any...) {
    if let valuesString = values as? [String] {
      let joinedString = valuesString.joined(separator: ", ")
      myPrint(name: name, joinedString)
    } else {
      myDump(name: name, values)
    }
  }

}


// MARK: - Prefix

extension Logger {

  private static let DEFAULT_PREFIX = "Never Forget"

  private static func getPrefix(case prefix: String, usersPrefix: String?) -> String {
    let prefixes = [DEFAULT_PREFIX, usersPrefix, prefix].compactMap { $0 }

    return prefixes.joined(separator: " ")
  }

}
