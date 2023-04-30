import UserNotifications

public class NFLocalNotificationsManager {

  private let center = UNUserNotificationCenter.current()
  private let userDefaultsManager = NFLNUserDefaultManager()

  public var isDenied: Bool {
    userDefaultsManager.getBool(.isDenied)
  }

  public init() {}

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

      completion(false)
    }
  }

  func checkAuthorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
    center.getNotificationSettings { settings in
      completion(settings.authorizationStatus)
    }
  }

  private func requestPermission(completion: @escaping (IsSuccessAuthorization) -> Void) {
    center.requestAuthorization(options: [.alert, .badge, .sound]) { isSuccess, _ in
      self.setIsDenied(!isSuccess)
      completion(isSuccess)
    }
  }

  private func setIsDenied(_ value: Bool) {
    userDefaultsManager.setBool(value, key: .isDenied)
  }

}

// MARK: - Schedule local notification

extension NFLocalNotificationsManager {}
