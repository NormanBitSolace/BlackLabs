import UIKit
import MessageUI

public extension UIViewController {
    /// Loads a `UIViewController` of type `T` with storyboard. Assumes that the storyboards Storyboard ID has the same name as the storyboard and that the storyboard has been marked as Is Initial View Controller.
    /// - Parameter storyboardName: Name of the storyboard without .xib/nib suffix.
    static func loadStoryboard<T: UIViewController>(_ storyboardName: String) -> T? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: storyboardName) as? T {
            if #available(iOS 9.0, *) {
                vc.loadViewIfNeeded()
            } else {
                vc.view.frame = vc.view.bounds
            }
            return vc
        }
        return nil
    }
}

public extension UIViewController {
    func okAlert(title: String? = nil, message: String? = nil, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: completion)
    }

    @available(iOS 11.0, *)
    func setLargeNavigation(useLargeNavigation: Bool = true) {
        if useLargeNavigation {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationItem.largeTitleDisplayMode = .always
            navigationController?.navigationBar.isTranslucent = false
        } else {
            navigationController?.navigationBar.prefersLargeTitles = false
            // navigationItem.largeTitleDisplayMode = .never
        }
    }
}

public extension UIViewController {
    func email(includeBuildNumber: Bool = false) {
        if MFMailComposeViewController.canSendMail() {
            let subject = "\(Bundle.main.appName) \(includeBuildNumber ? Bundle.main.appNameAndVersion : Bundle.main.version) \(UIDevice.modelName) iOS: \(UIDevice.current.systemVersion)"
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["puzzlepleasure@gmail.com"])
            mail.setSubject(subject)
            self.present(mail, animated: true)
        } else {
            okAlert(title: "This device is not setup to send email yet.")
        }
    }
}
extension UIViewController: MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

public extension UIViewController {

    func rightButton(title: String?, style: UIBarButtonItem.Style = .plain, target: Any?, action: Selector?) {
        let button = UIBarButtonItem(title: title, style: style, target: target, action: action)
        navigationItem.rightBarButtonItem = button
    }

    func rightButton(systemItem: UIBarButtonItem.SystemItem, target: Any?, action: Selector?) {
        let button = UIBarButtonItem(barButtonSystemItem: systemItem, target: target, action: action)
        self.navigationItem.rightBarButtonItem = button
    }

    func addDoneButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissViewController as () -> Void))
    }

    func applyDismissActionToRightBarButtonItem() {
        self.navigationItem.rightBarButtonItem?.action = #selector(self.dismissViewController as () -> Void)
        self.navigationItem.rightBarButtonItem?.target = self
    }

    @objc func dismissViewController() {
        self.dismiss(animated: true, completion: nil)
    }

    static var topMostController: UIViewController? {
        guard let window = UIApplication.shared.keyWindow, let rootViewController = window.rootViewController else {
            return nil
        }
        var topController = rootViewController
        while let newTopController = topController.presentedViewController {
            topController = newTopController
        }
        return topController
    }

    func printTransitionStates() {
        print("isBeingPresented=\(isBeingPresented)")
        print("isBeingDismissed=\(isBeingDismissed)")
        print("isMovingToParentViewController=\(isMovingToParent)")
        print("isMovingFromParentViewController=\(isMovingFromParent)")
    }
}

public extension UIViewController {

    func isTopViewController() -> Bool {
        return self.navigationController?.visibleViewController == self
    }

    func viewFromClassName(_ name: String) -> UIView? {
        if let viewClass = name.toClass() as? UIView.Type {
            return viewClass.init(frame: .zero)
        }
        return nil
    }
}
