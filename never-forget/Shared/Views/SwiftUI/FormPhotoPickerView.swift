//
//  FormPhotoPickerView.swift
//  never-forget
//
//  Created by makar on 2/25/23.
//

import PhotosUI
import SwiftUI

struct FormPhotoPickerView: View {
  @Binding var selectedPhoto: PhotosPickerItem?
  @Binding var imageData: Data?

  var body: some View {
    PhotosPicker(selection: $selectedPhoto, matching: .not(.videos)) {
      VStack(alignment: .center) {
        DecodedImageWithPlaceholder(data: $imageData,
                                    placeholder: Image(systemName: "person").resizable().padding(30),
                                    frame: CGSize(width: 100, height: 100))
          .scaledToFill()
          .frame(width: 100, height: 100)
          .cornerRadius(100)
      }
    }
    .frame(maxWidth: .infinity)
    .onChange(of: selectedPhoto) { newPhoto in
      guard let photo = newPhoto else { return }

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

struct PhotoPickerView_Previews: PreviewProvider {
  static var previews: some View {
    FormPhotoPickerView(selectedPhoto: .constant(nil), imageData: .constant(nil))
  }
}
