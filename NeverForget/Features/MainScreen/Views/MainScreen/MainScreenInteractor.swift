//
//  MainScreenInteractor.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 14.09.2023
//

protocol IMainScreenInteractor: AnyObject {}

class MainScreenInteractor: IMainScreenInteractor {
  weak var presenter: IMainScreenPresenter?
}
