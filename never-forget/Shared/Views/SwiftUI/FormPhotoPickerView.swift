//
//  FormPhotoPickerView.swift
//  never-forget
//
//  Created by makar on 2/25/23.
//

import SwiftUI

struct FormPhotoPickerView: View {
  @Binding var imageData: Data?

  @State private var isPresentedImagePicker = false
  @State private var selectedImage: UIImage?
  @State private var isLoadingPhoto = false

  let compressionQuality: CGFloat

  init(imageData: Binding<Data?>, compressionQuality: CGFloat = 0.5) {
    _imageData = imageData
    self.compressionQuality = compressionQuality
  }

  var body: some View {
    Menu {
      Button("Add") { // TODO: translate
        isPresentedImagePicker = true
      }
      Button("Delete", role: .destructive) { // TODO: translate
        imageData = nil
        selectedImage = nil
      }
      .disabled(imageData == nil)
    } label: {
      DecodedImageWithPlaceholder(
        data: $imageData,
        placeholder: Image(systemName: "person").resizable().padding(30),
        frame: CGSize(width: 100, height: 100),
        isLoading: $isLoadingPhoto
      )
      .scaledToFill()
      .frame(width: 100, height: 100)
      .cornerRadius(100)
    }
    .frame(maxWidth: .infinity)
    .onChange(of: selectedImage, perform: { newImage in
      DispatchQueue.main.async {
        if let image = newImage?.jpegData(compressionQuality: compressionQuality) {
          imageData = image
        }
      }
    })
    .sheet(isPresented: $isPresentedImagePicker) {
      ImagePicker(selectedImage: $selectedImage, isLoading: $isLoadingPhoto)
    }
  }
}

struct PhotoPickerView_Previews: PreviewProvider {
  static var previews: some View {
    FormPhotoPickerView(imageData: .constant(nil))
  }
}
