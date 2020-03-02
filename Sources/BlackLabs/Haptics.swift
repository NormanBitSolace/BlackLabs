import UIKit

public class Haptics {

    public enum Level: Int {
        case ultraLight, light, lightMedium, medium, heavyMedium, heavy, veryHeavy
    }

    static public func vibrate(_ level: Level) {
        if #available(iOS 10.0, *) {
            guard UserDefaults.getb("useHaptics") else { return }
            switch level {
            case .ultraLight:
                let generator = UISelectionFeedbackGenerator()
                generator.selectionChanged()
            case .light:
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
            case .lightMedium:
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
            case .medium:
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
            case .heavyMedium:
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.warning)
            case .heavy:
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            case .veryHeavy:
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
            }
        }
    }
}

