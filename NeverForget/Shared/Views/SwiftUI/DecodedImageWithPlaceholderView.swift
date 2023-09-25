//
//  DecodedImageWithPlaceholderView.swift
//  never-forget
//
//  Created by makar on 3/4/23.
//

import SwiftUI

private enum DecodedImageDrawerQueueProvider {
  static let imageDrawerQueue = DispatchQueue(label: "com.NeverForget.imageDrawerQueue", qos: .userInteractive)
}

struct DecodedImageWithPlaceholderView<PlaceholderImage: View>: View {

  let placeholder: PlaceholderImage
  let onLoadEnd: () -> Void
  let frame: CGSize

  var imageData: Data?
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
    imageData: Data?,
    placeholder: PlaceholderImage,
    frame: CGSize,
    isLoading: Binding<Bool> = .constant(false),
    onLoadEnd: @escaping () -> Void = {}
  ) {
    self.imageData = imageData
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
      }
    }
    .onAppear {
      loadAsyncImage(data: imageData)
    }
    .onChange(of: imageData, perform: { newData in
      loadAsyncImage(data: newData)
    })
  }

}


extension DecodedImageWithPlaceholderView {

  private func loadAsyncImage(data: Data?) {
    localIsLoading = true

    DecodedImageDrawerQueueProvider.imageDrawerQueue.async {
      guard let data, let decodedImage = UIImage(data: data) else {
        DispatchQueue.main.async {
          onLoadEnd()
          localIsLoading = false
          decodedImage = nil
        }
        return
      }

      let resizableImage = decodedImage.resized(maxSize: frame)
      let image = Image(uiImage: resizableImage)

      DispatchQueue.main.async {
        self.decodedImage = image
        onLoadEnd()
        localIsLoading = false
      }
    }
  }

}

struct DecodedImageWithPlaceholder_Previews: PreviewProvider {
  static var previews: some View {
    DecodedImageWithPlaceholderView(
      imageData: Data(),
      placeholder: Image("person"),
      frame: CGSize(width: 100, height: 100)
    )
  }
}
