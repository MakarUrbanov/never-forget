//
//  AsyncImageLoader.swift
//  NeverForgetApp
//
//  Created by makar on 5/12/23.
//

import UIKit

final class AsyncImageLoader {

  static let shared = AsyncImageLoader()
  private init() {}

  private static let imageLoaderQueue = DispatchQueue(
    label: "com.NeverForget.asyncImageLoader", qos: .userInteractive, attributes: .concurrent
  )

  func fromData(_ imageData: Data?, completion: @escaping (UIImage) -> Void) {
    guard let imageData else { return }

    AsyncImageLoader.imageLoaderQueue.async {
      guard let image = UIImage(data: imageData) else { return }

      DispatchQueue.main.async {
        completion(image)
      }
    }
  }

}
