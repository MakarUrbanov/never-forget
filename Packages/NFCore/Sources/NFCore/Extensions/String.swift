import Foundation

// MARK: - localizedString
public extension String {
  static func localizedString(
    for key: String,
    locale: Locale = .current
  ) -> String {
    let language = locale.language.languageCode?.identifier ?? "en"
    guard let path = Bundle.main.path(forResource: language, ofType: "lproj"),
          let bundle = Bundle(path: path) else { fatalError(#function) }

    let localizedString = NSLocalizedString(key, bundle: bundle, comment: "")

    return localizedString
  }
}

// MARK: - Random string
public extension String {
  private static let ALL_LETTERS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  private static func getRandomLetter() -> Character { String.ALL_LETTERS.randomElement() ?? Character("a") }

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

// MARK: - trim
public extension String {
  func trim() -> String {
    trimmingCharacters(in: .whitespacesAndNewlines)
  }
}

// MARK: - capitalizeFirst
public extension String {
  func capitalizeFirst() -> String {
    let firstLetter = prefix(1).capitalized
    let remainingLetters = dropFirst()
    return firstLetter + remainingLetters
  }
}
