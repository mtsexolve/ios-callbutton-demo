import SwiftUI

class Alert {
    private static var active = false

    static func show(_ title: String, _ message: String) {
        if Alert.active {
            return;
        }

        Alert.active = true
        DispatchQueue.main.async {
            if let vc = getTopViewController() {
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                vc.present(alert, animated: true, completion: nil)
                let hide = { (_: Timer) in
                    alert.dismiss(animated: true, completion: nil)
                    alert.removeFromParent()
                    Alert.active = false
                }
                Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: hide)
            }
        }
    }

    static private func getTopViewController() -> UIViewController? {
        var vc = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController
        while let presentedViewController = vc?.presentedViewController {
            vc = presentedViewController
        }
        return vc
    }

}
