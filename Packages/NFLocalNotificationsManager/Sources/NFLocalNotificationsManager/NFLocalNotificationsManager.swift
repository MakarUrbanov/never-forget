import UserNotifications

public class NFLocalNotificationsManager {

  let center = UNUserNotificationCenter.current()

  let attachmentManager = NFLNNotificationAttachmentManager.shared

  public init() {}

  public func getPendingNotifications() async -> [UNNotificationRequest] {
    return await center.pendingNotificationRequests()
  }

}

// MARK: - Authorization

public extension NFLocalNotificationsManager {

  typealias IsSuccessAuthorization = Bool
  func requestFirstPermission() async -> Bool {
    let authorizationStatus = await checkAuthorizationStatus()
    let isStatusNotDetermined = authorizationStatus == .notDetermined

    if isStatusNotDetermined {
      do {
        let isSucceed = try await requestPermission()
        return isSucceed
      } catch {
        return false
      }
    }

    return authorizationStatus != .denied
  }

  func checkAuthorizationStatus() async -> UNAuthorizationStatus {
    return await center.notificationSettings().authorizationStatus
  }

  private func requestPermission() async throws -> Bool {
    do {
      let isSucceed = try await center.requestAuthorization(options: [.alert, .badge, .sound])
      return isSucceed
    } catch {
      NFLNLogger.error(message: "Request a permission error", error)
      throw error
    }
  }

}

// MARK: - Notifications

public extension NFLocalNotificationsManager {

  func removeNotification(identifiers: [String]) async {
    let notifications = await getPendingNotifications()

    center.removePendingNotificationRequests(withIdentifiers: identifiers)

    for notification in notifications where identifiers.contains(notification.identifier) {
      notification.content.attachments.forEach { attachment in
        self.attachmentManager.deleteExistingImage(at: attachment.url)
      }
    }
  }

  func scheduleAnnualNotification(_ notification: NFLNScheduledEventNotification) async throws {
    let content = configureContent(for: notification)

    let dateComponents = Calendar.current.dateComponents(
      [.month, .day, .hour, .minute],
      from: notification.date
    )

    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

    let request = UNNotificationRequest(identifier: notification.identifier, content: content, trigger: trigger)

    try await center.add(request)
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

    if let deepLink = notification.deepLink, let encodedDeepLink = try? JSONEncoder().encode(deepLink) {
      content.userInfo = ["deepLink": encodedDeepLink]
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
