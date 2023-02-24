//
//  AddNewPersonViewModel.swift
//  never-forget
//
//  Created by makar on 2/24/23.
//

import Foundation

final class AddNewPersonViewModel: ObservableObject {

  @Published var name = ""
  @Published var dateOfBirth = Date()
  @Published var description = ""

}
