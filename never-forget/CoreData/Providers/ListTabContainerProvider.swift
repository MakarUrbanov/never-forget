//
//  ListTabContainerProvider.swift
//  never-forget
//
//  Created by makar on 2/13/23.
//

import Foundation

class ListTabContainerProvider: PersistentContainerController {

  static let shared = ListTabContainerProvider()

  init() {
    super.init(storeName: "ListTab")
  }

}
