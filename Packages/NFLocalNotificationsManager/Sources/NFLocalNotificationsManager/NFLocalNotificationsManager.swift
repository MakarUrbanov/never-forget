import UserNotifications

public class NFLocalNotificationsManager {

  let center = UNUserNotificationCenter.current()

  let attachmentManager = NFLNNotificationAttachmentManager.shared

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
        NFLNLogger.error(message: "Request permission error", error)
      }
    }
  }

}

// MARK: - Notifications

public extension NFLocalNotificationsManager {

  func removeNotification(identifiers: [String]) {
    center.removePendingNotificationRequests(withIdentifiers: identifiers)
  }

  func scheduleAnnualNotification(
    _ notification: NFLNScheduledEventNotification,
    errorHandler: @escaping (String) -> Void
  ) {
    let content = configureContent(for: notification)

    let dateComponents = Calendar.current.dateComponents(
      [.month, .day, .hour, .minute],
      from: notification.date
    )
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

    let request = UNNotificationRequest(identifier: notification.identifier, content: content, trigger: trigger)

    center.add(request) { error in
      if let error {
        errorHandler(error.localizedDescription)
        NFLNLogger.error(message: "Scheduling notification error", error)
      }
    }
  }

}

// MARK: - Categories

public extension NFLocalNotificationsManager {

  func registerCategories(_ categories: Set<UNNotificationCategory>) {
    center.setNotificationCategories(categories)
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

    if let imageData = notification.image {
      do {
        let imageUrl = try attachmentManager.saveImage(imageData)
        let attachment = try UNNotificationAttachment(identifier: "image", url: imageUrl, options: nil)

        content.attachments = [attachment]
      } catch {
        NFLNLogger.error(message: "Error adding image to the attachments", error)
      }
    }

    return content
  }

}
