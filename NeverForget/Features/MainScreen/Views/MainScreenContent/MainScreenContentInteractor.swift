//
//  MainScreenContentInteractor.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 15.09.2023
//

import Foundation

protocol IMainScreenContentInteractor: AnyObject {}

class MainScreenContentInteractor: IMainScreenContentInteractor {

  weak var presenter: IMainScreenContentPresenter?

  init() {}

}
