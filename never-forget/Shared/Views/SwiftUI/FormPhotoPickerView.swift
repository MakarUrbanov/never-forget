//
//  FormPhotoPickerView.swift
//  never-forget
//
//  Created by makar on 2/25/23.
//

import PhotosUI
import SwiftUI

struct FormPhotoPickerView: View {
  @Binding var selectedPhotos: [PhotosPickerItem]
  @Binding var imageData: Data?

  var body: some View {
    PhotosPicker(selection: $selectedPhotos,
                 maxSelectionCount: 1,
                 selectionBehavior: .ordered,
                 matching: .not(.videos)) {
      VStack(alignment: .center) {
        if let imageData = imageData, let profileImage = UIImage(data: imageData) {
          Image(uiImage: profileImage)
            .resizable()
            .scaledToFill()
            .frame(width: 100, height: 100)
            .cornerRadius(100)
        } else {
          Image(systemName: "person")
            .resizable()
            .scaledToFit()
            .padding(30)
            .frame(width: 100, height: 100)
            .cornerRadius(100)
        }
      }
      .frame(maxWidth: .infinity)
      .onChange(of: selectedPhotos) { newPhotos in
        guard let photo = newPhotos.first else { return }

        photo.loadTransferable(type: Data.self) { result in
          switch result {
            case .success(let image):
              DispatchQueue.main.async {
                imageData = image
              }
            case .failure:
              break
          }
        }
      }
    }
  }
}

struct PhotoPickerView_Previews: PreviewProvider {
  static var previews: some View {
    FormPhotoPickerView(selectedPhotos: .constant([]), imageData: .constant(nil))
  }
}
