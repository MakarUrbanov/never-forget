//
//  ListTabView.swift
//  never-forget
//
//  Created by makar on 2/7/23.
//

import CoreData
import SwiftUI

struct ListTabView: View {

  @StateObject private var listTabPersistentContainer = ListTabContainerProvider.shared

  var body: some View {
    VStack {
      PersonsListView()
    }
    .environment(\.managedObjectContext, listTabPersistentContainer.viewContext)
  }
}


struct ListTabView_Previews: PreviewProvider {
  static var previews: some View {
    ListTabView()
  }
}
