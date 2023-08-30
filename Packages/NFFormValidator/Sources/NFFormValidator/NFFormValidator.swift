import Combine

public class NFFormValidator<FormNames: RawRepresentable>: ObservableObject where FormNames: Equatable {

  public typealias FormField = FormValidatorField<AnyHashable, FormNames>

  public var fields: [FormField]
  @Published public var isFormValid = true

  public init(fields: [FormField], validateOn: ValidateOn = .submit, isValidateOnInit: Bool = false) {
    self.fields = fields

    if validateOn == .change {
      setIsValidateOnChangeToFields()
    }

    if isValidateOnInit {
      isFormValid = checkIsFormValid()
    }
  }

  public func getField(_ name: FormNames) -> FormField? {
    fields.first(where: { $0.name == name })
  }

  private func checkIsFormValid() -> Bool {
    fields.allSatisfy { $0.validate() == .valid }
  }

  private func setIsValidateOnChangeToFields() {
    fields = fields.map { field in
      field.isValidateOnChange = true
      return field
    }
  }

}

public extension NFFormValidator {

  enum ValidateOn {
    case submit
    case change
  }

}
