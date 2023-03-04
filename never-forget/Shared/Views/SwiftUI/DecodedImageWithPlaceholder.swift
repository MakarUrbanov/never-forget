//
//  DecodedImageWithPlaceholder.swift
//  never-forget
//
//  Created by makar on 3/4/23.
//

import SwiftUI

struct DecodedImageWithPlaceholder<DefaultImage: View>: View {
  @Binding var data: Data?
  let placeholder: DefaultImage
  let onLoadEnd: () -> Void
  let frame: CGSize

  @State private var decodedImage: Image?
  @State private var isLoading = true

  init(data: Binding<Data?>, placeholder: DefaultImage, frame: CGSize, onLoadEnd: @escaping () -> Void = {}) {
    _data = data
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
          .onChange(of: data, perform: { newData in
            loadAsyncImage(data: newData)
          })
          .onAppear {
            loadAsyncImage(data: data)
          }
      }
    }
  }
}


extension DecodedImageWithPlaceholder {

  private func loadAsyncImage(data: Data?) {
    DispatchQueue.global(qos: .userInteractive).async {
      guard let data, let decodedImage = UIImage(data: data) else {
        onLoadEnd()
        isLoading = false
        return
      }

      let resizableImage = decodedImage.resizeImage(maxSize: frame)
      let image = Image(uiImage: resizableImage)

      DispatchQueue.main.async {
        self.decodedImage = image
        onLoadEnd()
        isLoading = false
      }
    }
  }

}

struct DecodedImageWithPlaceholder_Previews: PreviewProvider {
  static var previews: some View {
    DecodedImageWithPlaceholder(data: .constant(Data()), placeholder: Image("person"),
                                frame: CGSize(width: 100, height: 100))
  }
}
