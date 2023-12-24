//
//  EventsNotification+CoreDataClass.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 26.11.2023.
//
//

import CoreData
import Foundation

@objc(EventsNotification)
public class EventsNotification: NSManagedObject, Identifiable {

  @NSManaged public var hour: NSNumber?
  @NSManaged public var minute: NSNumber?
  @NSManaged public var event: Event?

  @NSManaged private var preEventTypeRaw: PreEventType.RawValue
  public var preEventType: PreEventType {
    get {
      PreEventType(rawValue: preEventTypeRaw)! // swiftlint:disable:this force_unwrapping
    }
    set {
      preEventTypeRaw = newValue.rawValue
    }
  }

  override public func awakeFromInsert() {
    super.awakeFromInsert()

    preEventTypeRaw = PreEventType.oneDayBefore.rawValue
  }

}

// MARK: - Static
public extension EventsNotification {

  enum PreEventType: Int16 {
    case oneWeekBefore = 1
    case oneDayBefore = 2
    case onTheDayOfEvent = 3
  }

}
