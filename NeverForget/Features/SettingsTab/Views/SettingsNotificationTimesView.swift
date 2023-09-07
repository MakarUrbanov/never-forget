//
//  SettingsNotificationTimesView.swift
//  NeverForgetApp
//
//  Created by makar on 4/30/23.
//

import SwiftUI

struct SettingsNotificationTimesView: View {

  @EnvironmentObject var viewModel: SettingsViewModel

  var notificationRules: Binding<SettingsViewModel.AppNotificationRulesAdapter> {
    Binding(projectedValue: $viewModel.localAppSettings.appNotificationRules)
  }

  var body: some View {
    VStack {
      Form {
        Section("Notification times") { // TODO: translate
          ForEach(notificationRules.onEventDayTimes, id: \.id) { $time in
            DatePicker("Notify at:", selection: $time.date, displayedComponents: .hourAndMinute) // TODO: translate
              .deleteDisabled(notificationRules.onEventDayTimes.count == 1)
          }
          .onDelete { indexSet in
            viewModel.deleteOnEventDayTime(indexSet)
          }

          Button("Add notification time") { // TODO: translate
            withAnimation {
              viewModel.addNewOnEventDayTime()
            }
          }
          .disabled(notificationRules.onEventDayTimes.count >= 5)
        }
      }
      .scrollContentBackground(.hidden)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.Theme.background)
    .onDisappear {
      viewModel.filterOnEventDayTimes()
      viewModel.sortOnEventDayTimes()
    }
  }
}

struct SettingsNotificationTimesView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsNotificationTimesView()
      .environmentObject(SettingsViewModel())
  }
}
