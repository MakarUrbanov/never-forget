//
//  DecodedImageWithPlaceholderView.swift
//  never-forget
//
//  Created by makar on 3/4/23.
//

import SwiftUI

struct DecodedImageWithPlaceholderView<DefaultImage: View>: View {
  let placeholder: DefaultImage
  let onLoadEnd: () -> Void
  let frame: CGSize

  private let imageDrawerQueue = DispatchQueue(label: "com.NeverForget.imageDrawerQueue", qos: .userInteractive)

  @Binding var data: Data?
  @State private var decodedImage: Image?

  @Binding var parentIsLoading: Bool
  @State private var localIsLoading = true {
    didSet {
      parentIsLoading = localIsLoading
    }
  }

  private var correctIsLoading: Bool {
    parentIsLoading || localIsLoading
  }

  init(
    data: Binding<Data?>,
    placeholder: DefaultImage,
    frame: CGSize,
    isLoading: Binding<Bool> = .constant(false),
    onLoadEnd: @escaping () -> Void = {}
  ) {
    _data = data
    self.placeholder = placeholder
    self.onLoadEnd = onLoadEnd
    self.frame = frame

    _parentIsLoading = isLoading
  }

  var body: some View {
    ZStack {
      if let decodedImage {
        decodedImage
          .resizable()
      } else {
        placeholder
          .opacity(correctIsLoading ? 0 : 1)
          .overlay {
            if correctIsLoading {
              ProgressView()
                .zIndex(2)
            }
          }
          .onAppear {
            loadAsyncImage(data: data)
          }
      }
    }
    .onChange(of: data, perform: { newData in
      loadAsyncImage(data: newData)
    })
  }

}


extension DecodedImageWithPlaceholderView {

  private func loadAsyncImage(data: Data?) {
    localIsLoading = true

    imageDrawerQueue.async {
      guard let data, let decodedImage = UIImage(data: data) else {
        onLoadEnd()
        localIsLoading = false
        decodedImage = nil
        return
      }

      let resizableImage = decodedImage.resizeImage(maxSize: frame)
      let image = Image(uiImage: resizableImage)

      self.decodedImage = image
      onLoadEnd()
      localIsLoading = false
    }
  }

}

struct DecodedImageWithPlaceholder_Previews: PreviewProvider {
  static var previews: some View {
    DecodedImageWithPlaceholderView(
      data: .constant(Data()),
      placeholder: Image("person"),
      frame: CGSize(width: 100, height: 100)
    )
  }
}
