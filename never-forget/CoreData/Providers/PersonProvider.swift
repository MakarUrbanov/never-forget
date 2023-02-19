//
//  PersonContainerProvider.swift
//  never-forget
//
//  Created by makar on 2/13/23.
//

import Foundation

class PersonProvider: PersistentContainerController {

  static let shared = PersonProvider()

  init() {
    super.init(storeName: "Person")
  }

}
