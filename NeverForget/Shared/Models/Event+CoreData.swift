//
//  Event+CoreDataClass.swift
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
  @NSManaged public var id: EventId
  @NSManaged public var date: Date
  @NSManaged public var name: String
  @NSManaged public var contactsIds: Set<Contact.ContactId>

  @NSManaged private var notificationScheduleRuleRaw: EventNotificationsSchedulingRule.RawValue
  var notificationScheduleRule: EventNotificationsSchedulingRule {
    get {
      EventNotificationsSchedulingRule(rawValue: notificationScheduleRuleRaw)!
    }
    set {
      notificationScheduleRuleRaw = newValue.rawValue
    }
  }
  @NSManaged public var notifications: Set<Date>

  // MARK: - Overrides
  override public func awakeFromInsert() {
    super.awakeFromInsert()
    id = UUID().uuidString
    date = Self.todayRoundedDate
    name = ""
    contactsIds = []
    notificationScheduleRuleRaw = EventNotificationsSchedulingRule.globalSettings.rawValue
    notifications = []
  }

}

// MARK: - Static
extension Event {

  // MARK: - Types
  public typealias EventId = String

  // MARK: - Static properties
  private static let todayRoundedDate: Date = DateInRegion(region: .UTC).dateAtStartOf(.day).date

  // MARK: - Static methods
  public static func fetchRequest() -> NSFetchRequest<Event> {
    return NSFetchRequest<Event>(entityName: "Event")
  }

}
