public class NFLogger {
  public let moduleName: String

  public init(moduleName: String) {
    self.moduleName = moduleName
  }

  public func error(
    message: String? = nil,
    _ values: Any?...,
    fileID: String = #fileID,
    function: String = #function,
    line: Int = #line
  ) {
    let placeInfo = "\(fileID), \(function), line: \(line)"
    let correctPrefix = getPrefix(caseType: "ERROR 🔴", placeInfo: placeInfo, message: message)
    toPrint(with: correctPrefix, values)
  }

  public func warning(
    message: String? = nil,
    _ values: Any?...,
    fileID: String = #fileID,
    function: String = #function,
    line: Int = #line
  ) {
    let placeInfo = "\(fileID), \(function), line: \(line)"
    let correctPrefix = getPrefix(caseType: "WARN 🟠", placeInfo: placeInfo, message: message)
    toPrint(with: correctPrefix, values)
  }

  public func info(
    message: String? = nil,
    _ values: Any?...,
    fileID: String = #fileID,
    function: String = #function,
    line: Int = #line
  ) {
    let placeInfo = "\(fileID), \(function), line: \(line)"
    let correctPrefix = getPrefix(caseType: "INFO 🔵", placeInfo: placeInfo, message: message)
    toPrint(with: correctPrefix, values)
  }

}

extension NFLogger {

  private func toDefaultDump(name: String, _ values: Any...) {
    dump(values, name: name)
  }

  private func toDefaultPrint(name: String, _ output: String) {
    print("\(name) \(output)")
  }

  private func toPrint(with name: String, _ values: Any...) {
    if let valuesString = values as? [String] {
      let joinedString = valuesString.joined(separator: ", ")
      toDefaultPrint(name: name, joinedString)
    } else {
      toDefaultDump(name: name, values)
    }
  }

  private func getPrefix(caseType: String, placeInfo: String, message: String?) -> String {
    let prefixes = [moduleName, caseType, placeInfo, message].compactMap { $0 }

    return prefixes.joined(separator: " ")
  }

}
