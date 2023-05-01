import UserNotifications

public class NFLocalNotificationsManager {

  let center = UNUserNotificationCenter.current()

  private let userDefaultsManager = NFLNUserDefaultManager()

  public init() {}

  public func getPendingNotifications(completions: @escaping ([UNNotificationRequest]) -> Void) {
    center.getPendingNotificationRequests { pendingNotifications in
      completions(pendingNotifications)
    }
  }

}

// MARK: - Authorization

public extension NFLocalNotificationsManager {

  typealias IsSuccessAuthorization = Bool

  func requestFirstPermission(completion: @escaping (IsSuccessAuthorization) -> Void = { _ in }) {
    checkAuthorizationStatus { status in
      if status == .notDetermined {
        self.requestPermission(completion: completion)

        return
      }
    }
  }

  func checkAuthorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
    center.getNotificationSettings { settings in
      completion(settings.authorizationStatus)
    }
  }

  private func requestPermission(completion: @escaping (IsSuccessAuthorization) -> Void) {
    center.requestAuthorization(options: [.alert, .badge, .sound]) { isSuccess, error in
      completion(isSuccess)

      if let error {
        print(#function, "error: \(error.localizedDescription)")
      }
    }
  }

}

// MARK: - Schedule local notification

public extension NFLocalNotificationsManager {

  func removeNotification(identifiers: [String]) {
    center.removePendingNotificationRequests(withIdentifiers: identifiers)
  }

  func scheduleAnnualNotification(
    _ notification: NFLNScheduledEventNotification,
    errorHandler: @escaping (String) -> Void
  ) {
    let content = configureContent(for: notification)

    // TODO: remove .second
    let dateComponents = Calendar.current.dateComponents(
      [.month, .day, .hour, .minute, .second],
      from: notification.date
    )
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

    let request = UNNotificationRequest(identifier: notification.identifier, content: content, trigger: trigger)

    center.add(request) { error in
      if let error {
        errorHandler(error.localizedDescription)
        print(#function, "Error \(error.localizedDescription)")
      }
    }
  }

  private func configureContent(for notification: NFLNScheduledEventNotification) -> UNMutableNotificationContent {
    let content = UNMutableNotificationContent()
    content.title = notification.title
    content.body = notification.body
    content.sound = UNNotificationSound.default

    if let deepLink = notification.deepLink {
      content.userInfo = ["deepLink": deepLink.link.absoluteString]
        .merging(deepLink.providedData, uniquingKeysWith: { $1 })
    }
    if let categoryIdentifier = notification.categoryIdentifier {
      content.categoryIdentifier = categoryIdentifier
    }

    return content
  }

}

// MARK: - Register categories

public extension NFLocalNotificationsManager {

  func registerCategories(_ categories: Set<UNNotificationCategory>) {
    center.setNotificationCategories(categories)
  }

}
