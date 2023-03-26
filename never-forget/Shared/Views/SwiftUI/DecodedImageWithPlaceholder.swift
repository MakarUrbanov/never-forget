//
//  DecodedImageWithPlaceholder.swift
//  never-forget
//
//  Created by makar on 3/4/23.
//

import SwiftUI

struct DecodedImageWithPlaceholder<DefaultImage: View>: View {
  let placeholder: DefaultImage
  let onLoadEnd: () -> Void
  let frame: CGSize

  @Binding var data: Data?
  @Binding var parentIsLoading: Bool

  @State private var decodedImage: Image?
  @State private var isLoading: Bool {
    didSet {
      parentIsLoading = isLoading
    }
  }

  var correctIsLoading: Bool {
    parentIsLoading || isLoading
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
    _isLoading = State(initialValue: isLoading.wrappedValue)
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
    .opacity(correctIsLoading ? 0 : 1)
    .overlay {
      if correctIsLoading { ProgressView() }
    }
    .animation(.easeInOut, value: correctIsLoading)
    .onChange(of: data, perform: { newData in
      loadAsyncImage(data: newData)
    })
  }
}


extension DecodedImageWithPlaceholder {

  private func loadAsyncImage(data: Data?) {
    DispatchQueue.global(qos: .userInteractive).async {
      guard let data, let decodedImage = UIImage(data: data) else {
        onLoadEnd()
        isLoading = false
        decodedImage = nil
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
    DecodedImageWithPlaceholder(
      data: .constant(Data()),
      placeholder: Image("person"),
      frame: CGSize(width: 100, height: 100)
    )
  }
}
