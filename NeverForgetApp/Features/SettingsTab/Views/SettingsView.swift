//
//  SettingsView.swift
//  NeverForgetApp
//
//  Created by makar on 4/20/23.
//

import SwiftUI

struct SettingsView: View {

  @StateObject var viewModel = SettingsViewModel()

  var notificationRules: Binding<SettingsViewModel.AppNotificationRulesAdapter> {
    Binding(projectedValue: $viewModel.localAppSettings.appNotificationRules)
  }

  @State var isExpanded = true
  @State var timesMOCK: [Int] = []

  var body: some View {
    VStack {
      Form {
        Section("Notification rules") {
          Toggle(
            "Notify one week before",
            isOn: notificationRules.isNotificationOneWeekBeforeEnabled
          )

          Toggle(
            "Notify one day before",
            isOn: notificationRules.isNotificationOneDayBeforeEnabled
          )

          Toggle(
            "Notify on the day",
            isOn: notificationRules.isNotificationOnEventDayEnabled
          )

          LabeledContent("Notificate in") {
            Button("Add") { // TODO: translate
              timesMOCK += [Int.random(in: 0 ... 10)]
            }
          }

          if !notificationRules.wrappedValue.onEventDayTimes.isEmpty {
            ForEach(timesMOCK, id: \.self) { time in
              Text("\(time)")
            }
            .padding(.horizontal)
            .animation(.easeIn, value: notificationRules.wrappedValue.onEventDayTimes.count)
          }

        }
      }
    }
    .scrollContentBackground(.hidden)
    .navigationTitle("Settings") // TODO: translate
    .background(Color.Theme.background)
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}
