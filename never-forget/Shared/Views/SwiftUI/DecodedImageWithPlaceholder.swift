//
//  DecodedImageWithPlaceholder.swift
//  never-forget
//
//  Created by makar on 3/4/23.
//

import SwiftUI

struct DecodedImageWithPlaceholder<DefaultImage: View>: View {
  let data: Data?
  let placeholder: DefaultImage
  let onLoadEnd: () -> Void
  let frame: CGSize

  @State private var decodedImage: Image?
  @State private var isLoading = true

  init(data: Data?, placeholder: DefaultImage, frame: CGSize, onLoadEnd: @escaping () -> Void = {}) {
    self.data = data
    self.placeholder = placeholder
    self.onLoadEnd = onLoadEnd
    self.frame = frame
  }

  var body: some View {
    ZStack {
      if let decodedImage {
        decodedImage
          .resizable()
      } else {
        placeholder
          .opacity(isLoading ? 0 : 1)
          .overlay {
            if isLoading { ProgressView() }
          }
          .onAppear {
            loadAsyncImage(data: data)
          }
      }
    }
  }
}

extension DecodedImageWithPlaceholder {

  private func loadAsyncImage(data: Data?) {
    print("mmk start")
    DispatchQueue.global(qos: .userInteractive).async {
      print("mmk 1", Date().timeIntervalSince1970)
      guard let data, let decodedImage = UIImage(data: data) else {
        onLoadEnd()
        isLoading = false
        return
      }

      print("mmk 2", Date().timeIntervalSince1970)
      let resizableImage = decodedImage.resizeImage(maxSize: frame)
      print("mmk 3", Date().timeIntervalSince1970)
      let image = Image(uiImage: resizableImage)
      print("mmk 4", Date().timeIntervalSince1970)

      DispatchQueue.main.async {
        print("mmk end")
        self.decodedImage = image
        onLoadEnd()
        isLoading = false
      }
    }
  }

}

struct DecodedImageWithPlaceholder_Previews: PreviewProvider {
  static var previews: some View {
    DecodedImageWithPlaceholder(data: Data(), placeholder: Image("person"), frame: CGSize(width: 100, height: 100))
  }
}
