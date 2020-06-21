import UIKit

public extension UITableView {
    func scrollToLastRow(inSection section: Int = 0, animated: Bool = true) {
        guard !visibleCells.isEmpty else { return }
        let numRows = numberOfRows(inSection: section)
        if numRows > 0 {
            let ip = IndexPath.init(row: numRows - 1, section: section)
            scrollToRow(at: ip, at: .bottom, animated: animated)
        }
    }
}
