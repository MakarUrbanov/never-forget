//
//  PersonsTableHeaderView.swift
//  NeverForgetApp
//
//  Created by makar on 5/21/23.
//

import UIKit

final class PersonsTableHeaderView: UITableViewHeaderFooterView {
  static let reuseIdentifier = String(describing: PersonsTableHeaderView.self)

  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)

    var backgroundConfig = defaultBackgroundConfiguration()
    backgroundConfig.backgroundColor = UIColor(resource: .background)
    backgroundConfig.cornerRadius = 0
    backgroundConfiguration = backgroundConfig
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setTitle(_ title: String) {
    var content = defaultContentConfiguration()
    content.text = title

    contentConfiguration = content
  }

}
