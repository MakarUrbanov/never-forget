//
//  DateTests.swift
//  never-forgetTests
//
//  Created by makar on 3/13/23.
//

@testable import NeverForgetApp
import XCTest

final class DateTests: XCTestCase {
  // swiftlint:disable implicitly_unwrapped_optional
  var sut: Date!

  override func setUp() {
    super.setUp()
    sut = Date()
  }

  override func tearDown() {
    sut = nil
    super.tearDown()
  }

  func testRandomDate() {
    let randomDate = Date.getRandomDate()
    let isDateRandom = Date().formatted(.dateTime.year().month().day()) != randomDate
      .formatted(.dateTime.year().month().day())
    XCTAssert(isDateRandom)
  }

}
