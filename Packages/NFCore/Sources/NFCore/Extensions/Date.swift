import Foundation

// MARK: - getRandomDate
public extension Date {
  /// Get random date between 1900-01-01 and Today date
  static func getRandomDate() -> Date {
    let calendar = Calendar.current
    guard let year = calendar.dateComponents([.year], from: Date()).year else { return Date() }

    let randomizedYear = Int.random(in: 1_900...year)
    let randomizedMonth = Int.random(in: 1...12)
    let randomizedDay = Int.random(in: 1...28)

    let dateComponents = DateComponents(year: randomizedYear, month: randomizedMonth, day: randomizedDay)

    return Calendar.current.date(from: dateComponents) ?? Date()
  }
}
