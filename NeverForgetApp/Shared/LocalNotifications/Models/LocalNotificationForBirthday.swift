//
//  LocalNotificationForBirthday.swift
//  NeverForgetApp
//
//  Created by makar on 5/1/23.
//

import Foundation
import NFLocalNotificationsManager

struct LocalNotificationForBirthday: LocalNotificationProtocol {

  let type: BirthdayNotificationType
  let identifier: String
  let username: String
  let date: Date
  let deepLink: NFLNDeepLink?
  let image: Data?

  func makeNFLNScheduledEventNotification() -> NFLNScheduledEventNotification {
    let title = LocalNotificationForBirthday.generateTitle(type: type, date: date)
    let body = LocalNotificationForBirthday.generateBody(type: type, date: date, username: username)

    return NFLNScheduledEventNotification(
      identifier: identifier,
      title: title,
      body: body,
      date: date,
      deepLink: deepLink,
      categoryIdentifier: nil,
      image: image
    )
  }

}

// MARK: - Helpers

extension LocalNotificationForBirthday {

  enum BirthdayNotificationType {
    case oneWeekBefore
    case oneDayBefore
    case onEventDate
  }

  private static func generateTitle(type: BirthdayNotificationType, date: Date) -> String {
    switch type {
      case .oneWeekBefore:
        return LocalNotificationForBirthday.NotificationContentGenerator.generateRandomTitleForOneWeekBefore()
      case .oneDayBefore:
        return LocalNotificationForBirthday.NotificationContentGenerator.generateRandomTitleForOneDayBefore()
      case .onEventDate:
        let hour = Calendar.current.component(.hour, from: date)
        return LocalNotificationForBirthday.NotificationContentGenerator.generateRandomTitleForOnEventDate(hour: hour)
    }
  }

  private static func generateBody(type: BirthdayNotificationType, date: Date, username: String) -> String {
    switch type {
      case .oneWeekBefore:
        return LocalNotificationForBirthday.NotificationContentGenerator
          .generateRandomBodyForOneWeekBefore(username: username)
      case .oneDayBefore:
        return LocalNotificationForBirthday.NotificationContentGenerator
          .generateRandomBodyForOneDayBefore(username: username)
      case .onEventDate:
        let hour = Calendar.current.component(.hour, from: date)
        return LocalNotificationForBirthday.NotificationContentGenerator
          .generateRandomBodyForOnEventDate(username: username, hour: hour)
    }
  }

}


// MARK: - NotificationContentGenerator

// TODO: translate texts
private extension LocalNotificationForBirthday {
  enum NotificationContentGenerator {

    // MARK: - 1 WEEK BEFORE

    private static func getOneWeekBeforeTitles() -> [String] { [
      "⏰ One week to go 🎂",
      "📆 Mark your calendar 🎉",
      "🎁 Birthday countdown begins 🎈",
      "🌟 One week until the big day 🎊",
      "⌛️ 7 days left to prepare 🎁"
    ] }

    private static func getOneWeekBeforeBodies(username: String) -> [String] { [
      // swiftlint:disable line_length
      "Heads up! Your friend \(username) has a birthday in just one week. Time to brainstorm for the perfect gift and heartfelt wishes 🎈🎁",
      "A friendly reminder that \(username)'s birthday is coming up in a week. Start thinking about a special gift and a memorable message 🎊🎈",
      "Get ready! In just one week, it's your friend \(username)'s birthday. Plan a thoughtful gift and a heartfelt congratulation 🎉💌",
      "Your friend \(username) is celebrating their birthday in a week! Time to consider a unique gift and a sweet birthday message 🎁🎂",
      "Attention! \(username)'s birthday is one week away. Get ready to surprise them with a meaningful gift and warm wishes 🎂🎉"
      // swiftlint:enable line_length
    ] }

    // MARK: - 1 DAY BEFORE

    private static func getOneDayBeforeTitles() -> [String] { [
      "🎊 The celebration is tomorrow",
      "🎉 One day to go",
      "🎈 Birthday eve reminder",
      "🎂 Almost time to celebrate",
      "⏰ 24 hours until the big day"
    ] }

    private static func getOneDayBeforeBodies(username: String) -> [String] { [
      // swiftlint:disable line_length
      "Attention! Tomorrow is your friend \(username)'s birthday. Last chance to buy a gift 🎁 and prepare your congratulations 💌",
      "Just one day left before \(username)'s birthday! Hurry up and get the perfect gift 🛍️, and don't forget to write a heartfelt message 🎈",
      "Don't forget, tomorrow is \(username)'s special day! Make sure to grab a gift 🎁 and think of a touching birthday wish 🌟",
      "Your friend \(username) has a birthday tomorrow! Get ready with a thoughtful present 🎁 and warm wishes 💌",
      "Tick tock! \(username)'s birthday is tomorrow. Grab your last-minute gift 🎁 and prepare your birthday message 🎉"
      // swiftlint:enable line_length
    ] }

    // MARK: - ON THE BIRTHDAY DATE (Morning, Day, Evening)

    // MARK: Morning

    private static func getOnTheBirthdayMorningTitles() -> [String] { [
      "🌞 Rise and shine! It's a birthday",
      "☕ Morning birthday reminder",
      "🎈 Start the day with celebration"
    ] }

    private static func getOnTheBirthdayMorningBodies(username _: String) -> [String] { [
      // swiftlint:disable line_length
      "Good morning! Today is (username)'s birthday 🎉 Don't forget to send your best wishes and make their day special 🎁",
      "Hey there! Just a morning reminder that today is (username)'s birthday 🎂 Time to shower them with love and wishes 🌟",
      "Wake up and celebrate! Today is (username)'s special day 🎈 Send your warmest wishes and spread the birthday cheer 🎊"
      // swiftlint:enable line_length
    ] }

    // MARK: Day

    private static func getOnTheBirthdayDayTitles() -> [String] { [
      "🌤️ Midday birthday alert",
      "🎂 A friendly birthday reminder",
      "🌻 Don't forget the birthday"
    ] }

    private static func getOnTheBirthdayDayBodies(username _: String) -> [String] { [
      "It's noon already! Have you wished (username) a happy birthday? If not, now's the perfect time 🥳🎁",
      "In case you missed it, today is (username)'s birthday 🎉 Don't forget to send your heartfelt wishes 💌",
      "A sunny reminder: Today is (username)'s special day! 🌞 Make sure to send your warmest birthday greetings 🎈🎊"
    ] }

    // MARK: Evening

    private static func getOnTheBirthdayEveningTitles() -> [String] { [
      "🌆 Evening birthday nudge",
      "🌙 A night-time birthday reminder",
      "🌟 Birthday wishes under the stars"
    ] }

    private static func getOnTheBirthdayEveningBodies(username _: String) -> [String] { [
      // swiftlint:disable line_length
      "The day is almost over, but it's not too late to wish (username) a happy birthday 🎂🌛",
      "As the sun sets, don't forget to send your warm birthday wishes to (username) and make their night special 🌟🎉",
      "Before the day ends, be sure to celebrate (username)'s birthday under the stars 🌌 Send your best wishes and end the day on a high note 🎊"
      // swiftlint:enable line_length
    ] }

    // MARK: - Generate for the one week before

    // swiftlint:disable force_unwrapping
    static func generateRandomTitleForOneWeekBefore() -> String {
      getOneWeekBeforeTitles().randomElement()!
    }

    static func generateRandomBodyForOneWeekBefore(username: String) -> String {
      getOneWeekBeforeBodies(username: username).randomElement()!
    }

    // MARK: - Generate for the one day before

    static func generateRandomTitleForOneDayBefore() -> String {
      getOneDayBeforeTitles().randomElement()!
    }

    static func generateRandomBodyForOneDayBefore(username: String) -> String {
      getOneDayBeforeBodies(username: username).randomElement()!
    }

    // MARK: - Generate for the one the birthday date

    static func generateRandomTitleForOnEventDate(hour: Int) -> String {
      switch hour {
        case 0...12:
          return getOnTheBirthdayMorningTitles().randomElement()!
        case 13...19:
          return getOnTheBirthdayDayTitles().randomElement()!
        default:
          return getOnTheBirthdayEveningTitles().randomElement()!
      }
    }

    static func generateRandomBodyForOnEventDate(username: String, hour: Int) -> String {
      switch hour {
        case 0...12:
          return getOnTheBirthdayMorningBodies(username: username).randomElement()!
        case 13...19:
          return getOnTheBirthdayDayBodies(username: username).randomElement()!
        default:
          return getOnTheBirthdayDayBodies(username: username).randomElement()!
      }
    }


  }
}
