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
