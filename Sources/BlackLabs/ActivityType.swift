import UIKit

extension UIActivity.ActivityType: CustomStringConvertible {
    public var description: String {
        var target = "Unknown"
        switch self {
        case .postToFacebook:
            target = "Facebook"
        case .postToTwitter:
            target = "Twitter"
        case .postToWeibo:
            target = "Weibo"
        case .message:
            target = "Message"
        case .mail:
            target = "Mail"
        case .print:
            target = "Print"
        case .copyToPasteboard:
            target = "Clipboard"
        case .assignToContact:
            target = "Assign To Contact"
        case .saveToCameraRoll:
            target = "Save To Camera Roll"
        case .addToReadingList:
            target = "Add To Reading List"
        case .postToFlickr:
            target = "Flickr"
        case .postToVimeo:
            target = "Vimeo"
        case .postToTencentWeibo:
            target = "Tencent Weibo"
        case .airDrop:
            target = "Air Drop"
/*
        // requires iOS 9
        case .openInIBooks:
            target = "Open In Books"
        // requires iOS 11
        case .markupAsPDF:
            target = "Mark As PDF"
*/
        default:
            target = "\(rawValue)"
        }
        if rawValue == "com.burbn.instagram.shareextension" {
            target = "Instagram"
        }
        return target
    }
}
