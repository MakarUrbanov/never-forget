import UserNotifications

public class NFLocalNotificationsManager {

  private let center = UNUserNotificationCenter.current()

  public init() {}

}

// MARK: - Authorization

extension NFLocalNotificationsManager {

  public typealias isSuccessAuthorization = Bool

  public func requestFirstPermission(completion: @escaping (isSuccessAuthorization) -> Void = { _ in }) {
    checkAuthorizationStatus { status in
      if status == .notDetermined {
        self.requestPermission(completion: completion)
      }
    }
  }

  public func checkAuthorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
    center.getNotificationSettings { settings in
      completion(settings.authorizationStatus)
    }
  }

  private func requestPermission(completion: @escaping (isSuccessAuthorization) -> Void) {
    center.requestAuthorization(options: [.alert, .badge]) { isSuccess, _ in
      completion(isSuccess)
    }
  }

}

// MARK: - Schedule local notification

extension NFLocalNotificationsManager {}
