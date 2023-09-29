//
//  MainScreenContentRouter.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 15.09.2023
//

protocol IMainScreenContentRouter: AnyObject {}

class MainScreenContentRouter: IMainScreenContentRouter {
  weak var viewController: IMainScreenContentView?
}
