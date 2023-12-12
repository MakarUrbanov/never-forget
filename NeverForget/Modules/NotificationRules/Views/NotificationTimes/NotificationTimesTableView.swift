//
//  NotificationTimesTableView.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 10.10.2023.
//

import UIKit

class NotificationTimesTableView: UITableView {

  let viewModel: INotificationTimesTableViewModel

  init(viewModel: INotificationTimesTableViewModel) {
    self.viewModel = viewModel
    super.init(frame: .zero, style: .plain)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
