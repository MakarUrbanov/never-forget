import Foundation

public protocol INFFormValidator: AnyObject {
  var fields: [INFObservableField] { get }
  func addField(_ field: INFObservableField)
  func startValidating()
  func stopValidating()
  func validate() -> Bool
}

public class NFFormValidator: INFFormValidator {

  // MARK: - Public properties
  public private(set) var fields: [Field] = []

  // MARK: - Init
  public init() {}

  // MARK: - Public methods
  public func addField(_ field: Field) {
    fields.append(field)
  }

  public func startValidating() {
    iterateFields {
      $0.isValidating = true
    }
  }

  public func stopValidating() {
    iterateFields {
      $0.isValidating = false
    }
  }

  public func validate() -> Bool {
    var isValid = true

    iterateFields { field in
      field.validate()
      let isFieldValid = field.isValid

      if !isFieldValid {
        isValid = false
      }
    }

    return isValid
  }

}

// MARK: - Private methods
private extension NFFormValidator {

  private func iterateFields(_ callback: (_ field: Field) -> Void) {
    fields.forEach(callback)
  }

}

// MARK: - Static
public extension NFFormValidator {

  typealias Field = INFObservableField

}
