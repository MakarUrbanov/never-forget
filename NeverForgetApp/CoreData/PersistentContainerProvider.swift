//
//  PersistentContainerProvider.swift
//  never-forget
//
//  Created by makar on 2/13/23.
//

import Foundation

class PersistentContainerProvider: PersistentContainerController {

  static let shared = PersistentContainerProvider()

  init() {
    super.init(storeName: "NeverForgetModels")
  }

}
