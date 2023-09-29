//
//  PhotosOfEventsOwnersCollectionView.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 15.09.2023.
//

import UIKit

protocol IEventsOwnersPhotosView: UICollectionView {
  func setPhotos(for events: [Event])
  func clearPhotos()
}

class PhotosOfEventsOwnersCollectionView: UICollectionView, IEventsOwnersPhotosView {

  var diffableDataSource: DiffableDataSource!

  init() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    super.init(frame: .zero, collectionViewLayout: layout)

    backgroundColor = .clear
    semanticContentAttribute = .forceRightToLeft
    register(EventOwnerPhotoView.self, forCellWithReuseIdentifier: Constants.photoCellIdentifier)
    isScrollEnabled = false
    delegate = self
    diffableDataSource = getDiffableDataSource()
    dataSource = diffableDataSource
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // TODO: mmk temp
  private var uniqueNumber: Int = 0

  // MARK: - Public methods
  func setPhotos(for events: [Event]) {
    let imagesData = Self.prepareImages(from: events)

    updateSnapshot(with: imagesData)
  }

  func clearPhotos() {
    clearSnapshot()
  }

}

// MARK: - UICollectionViewDelegate
extension PhotosOfEventsOwnersCollectionView: UICollectionViewDelegateFlowLayout {

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let collectionViewHeight = collectionView.bounds.height

    return CGSize(width: collectionViewHeight, height: collectionViewHeight)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    UIConstants.offsetBetweenPhotos
  }

}

// MARK: - Private methods
extension PhotosOfEventsOwnersCollectionView {

  private func updateSnapshot(with imagesData: [EventImageData]) {
    var snapshot = diffableDataSource.snapshot()

    if !snapshot.sectionIdentifiers.contains(0) {
      snapshot.appendSections([0])
    }

    snapshot.appendItems(imagesData)

    diffableDataSource.apply(snapshot, animatingDifferences: false)
  }

  private func clearSnapshot() {
    var snapshot = diffableDataSource.snapshot()
    snapshot.deleteAllItems()
    diffableDataSource.apply(snapshot, animatingDifferences: false)
  }

  private func getDiffableDataSource() -> DiffableDataSource {
    UICollectionViewDiffableDataSource(collectionView: self) { collectionView, indexPath, imageData in
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: Constants.photoCellIdentifier, for: indexPath
      ) as? EventOwnerPhotoView else {
        fatalError("Dequeue error")
      }

      if let image = imageData.image {
        cell.setImage(image)
      } else if let letter = imageData.letter {
        cell.setText(letter)
      }

      cell.layer.zPosition = CGFloat(Constants.maximumPhotos - indexPath.item)

      return cell
    }
  }

}

// MARK: - Static
extension PhotosOfEventsOwnersCollectionView {

  typealias DiffableDataSource = UICollectionViewDiffableDataSource<Int, EventImageData>

  enum Constants {
    static let maximumPhotos = 3
    static let photoCellIdentifier = String(describing: EventOwnerPhotoView.self)
  }

  enum UIConstants {
    static let offsetBetweenPhotos: CGFloat = -12
  }

  private static func prepareImages(from events: [Event]) -> [EventImageData] {
    var eventsImageData = events.map { event in
      let owner = event.owner
      let ownersFirstName = (owner?.lastName ?? "")
      let ownersLastName = (owner?.firstName ?? "")
      let ownersName = ownersLastName.isEmpty ? ownersLastName : ownersFirstName
      let firstLetter = ownersName.first?.uppercased()

      return EventImageData(image: owner?.photoData, letter: firstLetter)
    }

    /// cut rest photos from by maxPhotos
    if eventsImageData.count > Constants.maximumPhotos {
      var firstImageData = eventsImageData[0]
      firstImageData.image = nil
      let rest = eventsImageData.count - Constants.maximumPhotos
      firstImageData.letter = "\(rest)+"

      eventsImageData[0] = firstImageData
      eventsImageData.remove(atOffsets: .init(integersIn: (Constants.maximumPhotos + 1)...))
    }

    return eventsImageData
  }

  struct EventImageData: Hashable {
    let id: UUID = .init()
    var image: Data?
    var letter: String?

    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
  }

}

private extension UICollectionViewDiffableDataSource {

  typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<SectionIdentifierType, ItemIdentifierType>

}
