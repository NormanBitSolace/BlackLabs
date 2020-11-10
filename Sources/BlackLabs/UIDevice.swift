import UIKit

public struct ScreenSize {
    public static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    public static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    public static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    public static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

public enum ScreenType : Int, CaseIterable {
    /// 3.5 inch (iPhone 4, 4s, 2G, 3G, 3GS)
    case phone320by480
    /// 4 inch (iPhone 5, 5s, 5c, SE, iPod Touch 5th, 6h gen)
    case phone320by568
    /// 4.7 inch (iPhone 6, iPhone 6s, iPhone 7, iPhone 8)
    case phone375by667
    /// Display Zoom on  iPhone 11 Pro, iPhone 12 mini, iPhone 12, iPhone 12 Pro
    case phone320by693
    /// 5.5 inch (iPhone 6s Plus, iPhone 7 Plus, iPhone 8 Plus)
    case phone414by736
    /// 5.8 inch (iPhone 11 Pro, iPhone X, iPhone XS, iPhone 12 mini)
    case phone375by812
    /// 6.1 inch (iPhone 12, iPhone 12 Pro)
    case phone390by844
    /// 6.5 inch (iPhone 11 Pro Max, iPhone 11, iPhone XS Max, iPhone XR)
    case phone414by896
    /// 6.7 inch (iPhone 12 Pro Max)
    case phone428by926
    /// iPad Pro, iPad Air 2, iPad Mini 4
    case pad768by1024
    /// iPad 10.2
    case pad810by1080
    /// iPad Pro 10.5
    case pad834by1112
    /// iPad 10.9
    case pad820by1180
    /// iPad Pro 11
    case pad834by1194
    /// iPad Pro 12.9
    case pad1024by1366
}

public extension ScreenType {
    static var current: ScreenType {
        switch ScreenSize.SCREEN_MAX_LENGTH {
        case 480:
            return .phone320by480
        case 568:
            return .phone320by568
        case 667:
            return .phone375by667
        case 693:
            return .phone320by693
        case 736:
            return .phone414by736
        case 812:
            return .phone375by812
        case 844:
            return .phone390by844
        case 896:
            return .phone414by896
        case 926:
            return .phone428by926
        case 1024:
            return .pad768by1024
        case 1080:
            return .pad810by1080
        case 1112:
            return .pad834by1112
        case 1180:
            return .pad820by1180
        case 1194:
            return .pad834by1194
        case 1366:
            return .pad1024by1366
        default:
            //  some unrecognized future screen size, take best guess
            let area = ScreenSize.SCREEN_WIDTH * ScreenSize.SCREEN_HEIGHT
            var diff = CGFloat.greatestFiniteMagnitude
            var screenType = ScreenType.phone375by812
            for currentScreenType in ScreenType.allCases {
                let size = ScreenType.size(forScreenType: currentScreenType)
                let currArea = size.width * size.height
                let currDiff = abs(area - currArea)
                if currDiff < diff {
                    diff = currDiff
                    screenType = currentScreenType
                }
            }
            return screenType
        }
    }

    static func size(forScreenType screenType: ScreenType) -> CGSize {
        switch screenType {
        case .phone320by480: return CGSize(width: 320, height: 480)
        case .phone320by568: return CGSize(width: 320, height: 568)
        case .phone320by693: return CGSize(width: 320, height: 693)
        case .phone375by667: return CGSize(width: 375, height: 667)
        case .phone414by736: return CGSize(width: 414, height: 736)
        case .phone375by812: return CGSize(width: 375, height: 812)
        case .phone390by844: return CGSize(width: 390, height: 844)
        case .phone414by896: return CGSize(width: 414, height: 896)
        case .phone428by926: return CGSize(width: 428, height: 926)
        case .pad768by1024: return CGSize(width: 768, height: 1024)
        case .pad810by1080: return CGSize(width: 810, height: 1080)
        case .pad834by1112: return CGSize(width: 834, height: 1112)
        case .pad820by1180: return CGSize(width: 820, height: 1180)
        case .pad834by1194: return CGSize(width: 834, height: 1194)
        case .pad1024by1366: return CGSize(width: 1024, height: 1366)
        }
     }

    static func landscapeSize(forScreenType screenType: ScreenType) -> CGSize {
        let s = ScreenType.size(forScreenType: screenType)
        return CGSize(width: s.height, height: s.width)
    }
}

public extension UIDevice {

    static var hasSafeArea: Bool {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.windows[0].safeAreaInsets != .zero
        } else {
          return false
        }
    }

    static var safeAreaX: CGFloat {
        if #available(iOS 11.0, *) {
          return UIApplication.shared.windows[0].safeAreaLayoutGuide.layoutFrame.origin.x
        } else {
          return 0
        }
    }
}

public extension UIDevice {
    
    static let modelName: String = UIDevice.current.modelName
    static let isPad = UIDevice.current.userInterfaceIdiom == .pad
    static let isPhone = UIDevice.current.userInterfaceIdiom == .phone
    static let isSimulator = UIDevice.modelName.contains("Simulator")
    static var screenType = ScreenType.current
    static let size = ScreenType.size(forScreenType: screenType)
    static let landscapeSize = ScreenType.landscapeSize(forScreenType: screenType)

    var isPortrait: Bool { return UIApplication.shared.statusBarOrientation.isPortrait }
    var orientationSize: CGSize { return isPortrait ? UIDevice.size : UIDevice.landscapeSize }

    //  access with stored UIDevice.modelName
    fileprivate var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = (element.value as? Int8), value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        if let modelName = DEVICE_MODELS[identifier] {
            return modelName
        }
        return "Unknown"

    }
    
}
