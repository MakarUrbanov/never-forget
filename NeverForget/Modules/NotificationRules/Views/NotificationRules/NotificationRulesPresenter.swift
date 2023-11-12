//
//  NotificationRulesPresenter.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 10.10.2023
//

protocol INotificationRulesPresenterInput: AnyObject {
}

protocol INotificationRulesPresenterOutput: AnyObject {
}

class NotificationRulesPresenter {

  weak var view: INotificationRulesPresenterOutput?

}

// MARK: - INotificationRulesPresenterInput
extension NotificationRulesPresenter: INotificationRulesPresenterInput {
}
