//
//  NFLNLogger.swift
//
//
//  Created by makar on 5/2/23.
//

import Foundation
import NFLogger

enum NFLNLogger {

  private static let logger = NFLogger(moduleName: "NFLocalNotifications")

  static func error(
    message: String? = nil,
    _ values: Any?...,
    fileID: String = #fileID,
    function: String = #function,
    line: Int = #line
  ) {
    NFLNLogger.logger.error(message: message, values, fileID: fileID, function: function, line: line)
  }

  static func warn(
    message: String? = nil,
    _ values: Any?...,
    fileID: String = #fileID,
    function: String = #function,
    line: Int = #line
  ) {
    NFLNLogger.logger.warning(message: message, values, fileID: fileID, function: function, line: line)
  }

  static func info(
    message: String? = nil,
    _ values: Any?...,
    fileID: String = #fileID,
    function: String = #function,
    line: Int = #line
  ) {
    NFLNLogger.logger.info(message: message, values, fileID: fileID, function: function, line: line)
  }

}
