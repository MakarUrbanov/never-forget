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
            NavigationLink {
              SettingsNotificationTimesView()
                .environmentObject(viewModel)
            } label: {
              Text("Notification times (\(notificationRules.onEventDayTimes.count))") // TODO: translate
            }

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
