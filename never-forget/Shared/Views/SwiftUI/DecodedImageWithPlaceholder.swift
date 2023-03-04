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
          .onAppear {
            loadAsyncImage(data: data)
          }
      }
    }
  }
}

extension DecodedImageWithPlaceholder {

  private func loadAsyncImage(data: Data?) {
    DispatchQueue.global(qos: .background).async {
      guard let decodedImage = UIImage(data: data ?? Data()) else { return onLoadEnd() }

      let resizableImage = decodedImage.resizeImage(maxSize: frame)
      let image = Image(uiImage: resizableImage)

      DispatchQueue.main.async {
        self.decodedImage = image
        onLoadEnd()
      }
    }
  }

}

struct DecodedImageWithPlaceholder_Previews: PreviewProvider {
  static var previews: some View {
    DecodedImageWithPlaceholder(data: Data(), placeholder: Image("person"), frame: CGSize(width: 100, height: 100))
  }
}
