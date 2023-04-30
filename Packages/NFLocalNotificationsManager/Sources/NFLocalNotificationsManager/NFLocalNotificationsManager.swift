import UserNotifications

public class NFLocalNotificationsManager {

  private let center = UNUserNotificationCenter.current()

  public init() {}

}

// MARK: - Authorization

public extension NFLocalNotificationsManager {

  func requestFirstPermission(completion: @escaping (Bool, Error?) -> Void = { _, _ in }) {
    checkAuthorizationStatus { status in
      if status == .notDetermined {
        self.requestPermission(completion: completion)
      }
    }
  }

  func checkAuthorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
    center.getNotificationSettings { settings in
      completion(settings.authorizationStatus)
    }
  }

  private func requestPermission(completion: @escaping (Bool, Error?) -> Void) {
    center.requestAuthorization(options: [.alert, .badge]) { isSuccess, error in
      if isSuccess {
        completion(true, nil)
      } else if let error {
        completion(false, error)
      }
    }
  }

}

// MARK: - Schedule local notification

extension NFLocalNotificationsManager {}
