//
//  PersonProfileHeaderButtons.swift
//  never-forget
//
//  Created by makar on 2/26/23.
//

import SwiftUI

extension PersonProfileView {

  struct PersonProfileHeaderButtons: ToolbarContent {
    let isEditMode: Bool
    let goBack: () -> Void
    let save: () -> Void
    let add: () -> Void

    init(
      isEditMode: Bool,
      goBack: @escaping () -> Void,
      save: @escaping () -> Void,
      add: @escaping () -> Void
    ) {
      self.isEditMode = isEditMode
      self.goBack = goBack
      self.save = save
      self.add = add
    }

    var body: some ToolbarContent {
      if isEditMode {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Save") { // TODO: localize
            save()
          }
        }
      } else {
        ToolbarItem(placement: .navigationBarLeading) {
          Button("Cancel") { // TODO: localize
            goBack()
          }
        }

        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Add") { // TODO: localize
            add()
          }
        }
      }
    }
  }

}
