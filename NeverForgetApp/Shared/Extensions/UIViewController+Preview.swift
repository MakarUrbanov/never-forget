//
//  UIViewController+Preview.swift
//  NeverForgetApp
//
//  Created by Makar Mishchenko on 02.09.2023.
//

import SwiftUI
import UIKit

extension UIViewController {

  private struct Preview: UIViewControllerRepresentable {
    let viewController: UIViewController

    func makeUIViewController(context: Context) -> some UIViewController {
      viewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
  }

  func makePreview() -> some View {
    Preview(viewController: self).ignoresSafeArea()
  }

}
