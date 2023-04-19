//
//  PeopleListSectioned.swift
//  NeverForgetApp
//
//  Created by makar on 4/2/23.
//

import Foundation

struct PeopleListSectioned: Identifiable, Equatable {
  let id: String = UUID().uuidString
  var title: String
  let month: Int
  private(set) var persons: [Person]

  init(
    title: String,
    month: Int,
    persons: [Person]
  ) {
    self.title = title
    self.month = month
    self.persons = persons
  }

  mutating func pushPerson(_ person: Person) {
    persons += [person]
  }

}
