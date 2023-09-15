//
//  Event+CoreData.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 12.09.2023.
//
//

import CoreData
import SwiftDate

@objc(Event)
public class Event: NSManagedObject, Identifiable {

  // MARK: - Public Properties
  @NSManaged public var id: String
  @NSManaged public var date: Date
  @NSManaged public var name: String

  @NSManaged private var notificationScheduleRuleRaw: NotificationsSchedulingRule.RawValue
  public var notificationScheduleRule: NotificationsSchedulingRule {
    get {
      NotificationsSchedulingRule(rawValue: notificationScheduleRuleRaw)! // swiftlint:disable:this force_unwrapping
    }
    set {
      notificationScheduleRuleRaw = newValue.rawValue
    }
  }

  @NSManaged private var typeRaw: EventType.RawValue
  public var type: EventType {
    get {
      EventType(rawValue: typeRaw)! // swiftlint:disable:this force_unwrapping
    }
    set {
      typeRaw = newValue.rawValue
    }
  }

  @NSManaged public var notifications: Set<Notification>
  @NSManaged public var contacts: Set<Contact>

  @NSManaged public var owner: Contact?

  // MARK: - Overrides
  override public func awakeFromInsert() {
    super.awakeFromInsert()
    id = UUID().uuidString
    date = Self.todayRoundedDate
    name = ""
    notificationScheduleRuleRaw = NotificationsSchedulingRule.globalSettings.rawValue
    typeRaw = EventType.userCreated.rawValue
    notifications = []
    contacts = []
  }

}

// MARK: - Static
extension Event {

  // MARK: - Static properties
  private static let todayRoundedDate: Date = DateInRegion(region: .UTC).dateAtStartOf(.day).date

  // MARK: - Static methods
  public static func fetchRequest() -> NSFetchRequest<Event> {
    return NSFetchRequest<Event>(entityName: "Event")
  }

  public static func fetchRequestWithSorting(descriptors: [NSSortDescriptor]) -> NSFetchRequest<Event> {
    let request = fetchRequest()
    request.sortDescriptors = descriptors

    return request
  }

}

// MARK: - Models
public extension Event {

  enum NotificationsSchedulingRule: Int16 {
    /// Notifications disabled on this event
    case disabled = 1
    /// Notifications follows global app settings notification rules
    case globalSettings = 2
    /// Notifications follows custom rules from the event
    case customSettings = 3
  }

  enum EventType: Int16 {
    case systemGenerated = 0
    case userCreated = 1
  }

}
