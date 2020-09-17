import UIKit

public extension UIStackView {
    func removeArrangedSubviews() { arrangedSubviews.forEach { $0.removeFromSuperview() } }
}
