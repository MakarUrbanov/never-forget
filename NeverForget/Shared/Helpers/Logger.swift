//
//  Logger.swift
//  never-forget
//
//  Created by makar on 3/24/23.
//

import Foundation
import NFLogger

enum Logger {

  private static let logger = NFLogger(moduleName: "NFApp")

  static func error(
    message: String? = nil,
    _ values: Any?...,
    fileID: String = #fileID,
    function: String = #function,
    line: Int = #line
  ) {
    Logger.logger.error(message: message, values, fileID: fileID, function: function, line: line)
  }

  static func warn(
    message: String? = nil,
    _ values: Any?...,
    fileID: String = #fileID,
    function: String = #function,
    line: Int = #line
  ) {
    Logger.logger.warning(message: message, values, fileID: fileID, function: function, line: line)
  }

  static func info(
    message: String? = nil,
    _ values: Any?...,
    fileID: String = #fileID,
    function: String = #function,
    line: Int = #line
  ) {
    Logger.logger.info(message: message, values, fileID: fileID, function: function, line: line)
  }

}
