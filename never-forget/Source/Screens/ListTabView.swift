//
//  ListTabView.swift
//  never-forget
//
//  Created by makar on 2/7/23.
//

import CoreData
import SwiftUI

struct ListTabView: View {

  @StateObject private var personProvider = PersonProvider()
//  @FetchRequest(fetchRequest: Person.fetchRequest()) var persons

  var body: some View {
    Group {
      Text("List tab!")
    }
    .environment(\.managedObjectContext, personProvider.backgroundContext)
  }
}

struct ListTab_Previews: PreviewProvider {
  static var previews: some View {
    ListTabView()
  }
}
