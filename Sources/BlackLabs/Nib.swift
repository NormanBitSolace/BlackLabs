import UIKit

open class Nib: NSObject {

    @discardableResult public static func addView(to parentView: UIView, nibName: String) -> UIView? {
        guard exists(nibName: nibName) else {
            return nil
        }
        let nibStruct = UINib(nibName: nibName, bundle: Bundle.main).instantiate(withOwner: self, options: nil)
        if let view = nibStruct.first as? UIView {
            let views : [String : UIView] = ["subview": view]
            parentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            parentView.preservesSuperviewLayoutMargins = false
            parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subview]|", options: [], metrics: nil, views: views))
            parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subview]|", options: [], metrics: nil, views: views))
            return view
        }
        return nil
    }
    
    static func exists(nibName: String) -> Bool {
        if let _ = Bundle.main.path(forResource: nibName, ofType: "nib") {
            return true
        }
        return false
    }
}
