//
//  SettingsView.swift
//  NeverForgetApp
//
//  Created by makar on 4/20/23.
//

import SwiftUI

struct SettingsView: View {

  @StateObject var viewModel = SettingsViewModel()
  @Environment(\.keyboardShortcut) var keyboardShortcut

  var notificationRules: Binding<SettingsViewModel.AppNotificationRulesAdapter> {
    Binding(projectedValue: $viewModel.localAppSettings.appNotificationRules)
  }

  var body: some View {
    VStack {
      Form {
        Section("Notification rules") { // TODO: translate
          Toggle(
            "Notify 1 week before", // TODO: translate
            isOn: notificationRules.isNotificationOneWeekBeforeEnabled
          )

          Toggle(
            "Notify 1 day before", // TODO: translate
            isOn: notificationRules.isNotificationOneDayBeforeEnabled
          )
        }

        Section("On the event day") { // TODO: translate
          Toggle(
            "Notify on the event day", // TODO: translate
            isOn: notificationRules.isNotificationOnEventDayEnabled
          )

          if notificationRules.wrappedValue.isNotificationOnEventDayEnabled {
            ForEach(notificationRules.onEventDayTimes, id: \.id) { $time in
              DatePicker("Notify at:", selection: $time.date, displayedComponents: .hourAndMinute) // TODO: translate
                .deleteDisabled(notificationRules.onEventDayTimes.count == 1)
                .onChange(of: time.fullMinutes) { _ in
                  viewModel.sortOnEventDayTimes()
                }
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

      }
    }
    .scrollContentBackground(.hidden)
    .navigationTitle(Localizable.Tabs.settings)
    .background(Color.Theme.background)
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}
