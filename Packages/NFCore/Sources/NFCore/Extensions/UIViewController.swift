import SwiftUI
import UIKit

// MARK: - UIKit Preview
public extension UIViewController {
  private struct Preview: UIViewControllerRepresentable {
    let viewController: UIViewController

    func makeUIViewController(context: Context) -> some UIViewController {
      viewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
  }

  func makePreview() -> some View {
    Preview(viewController: self).ignoresSafeArea()
  }
}

// MARK: - presentBottomSheet
public extension UIViewController {
  enum BottomSheetDetents {
    case large
    case medium
    case custom(CGFloat)
    case contentSize
  }

  private func generateDetents(from detents: [BottomSheetDetents], on viewController: UIViewController) -> [UISheetPresentationController.Detent] {
    detents.map { detent in
      switch detent {
        case .large:
            .large()
        case .medium:
            .medium()
        case .custom(let height):
            .custom { _ in height }
        case .contentSize:
            .custom { [weak viewController] _ in viewController?.preferredContentSize.height }
      }
    }
  }

  func presentBottomSheet(
    _ viewController: UIViewController,
    detents: [BottomSheetDetents],
    completion: (() -> Void)? = nil
  ) {
    viewController.modalPresentationStyle = .pageSheet

    if let sheet = viewController.sheetPresentationController {
      sheet.detents = generateDetents(from: detents, on: viewController)

      sheet.prefersGrabberVisible = true
      sheet.preferredCornerRadius = 16
    }

    present(viewController, animated: true, completion: completion)
  }

}
