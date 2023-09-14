//
//  MainScreenRouter.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 14.09.2023
//

protocol IMainScreenRouter: AnyObject {}

class MainScreenRouter: IMainScreenRouter {
  weak var viewController: IMainScreenView?
}
