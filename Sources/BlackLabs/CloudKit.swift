import UIKit
import CloudKit

public extension CKRecord {

    static func fetchRecordAsset(recordName: String, assetName: String, completion: @escaping (String?)->Swift.Void) {
        let publicDatabase = CKContainer.default().publicCloudDatabase
        let recordId = CKRecord.ID(recordName: recordName)
        publicDatabase.fetch(withRecordID: recordId) { (record, error) in
            if let text = record?.stringFromAsset(assetName: assetName) {
                completion(text)
            }
            completion(nil)
        }
    }
    
    func stringFromAsset(assetName: String) -> String? {
        if let asset = self[assetName] as? CKAsset,
        let content = FileManager.default.contents(atPath: asset.fileURL!.path) ,
            let text = NSString(data: content, encoding: String.Encoding.utf8.rawValue) as String? {
            return text
        }
        return nil
    }
    
/*
    Do this once. It should appear https://icloud.developer.apple.com/dashboard/#containers/iCloud.dailyPuzzles/environments/Development/data/subscriptions/public
     import CloudKit
     CKRecord.subscribeToRecordUpdate(recordType: "FileAssetRecord") { (error) in
     if error == nil { print("success") }
     }
*/
    static func subscribeToRecordUpdate(recordType: String, completion: @escaping (Error?)->Swift.Void) {
        let subscription = CKSubscription(
            recordType: recordType,
            predicate: NSPredicate(value: true),
            options: .firesOnRecordUpdate
        )
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.shouldSendContentAvailable = true
        subscription.notificationInfo = notificationInfo
        
        let publicDatabase = CKContainer.default().publicCloudDatabase
        publicDatabase.save(subscription) { (sub, error) in
            completion(error)
        }
    }
}

public extension CKNotification {
    
    static func recordId(fromUserInfo userInfo: [AnyHashable : Any]) ->CKRecord.ID? {
        let ckNotification = CKNotification(fromRemoteNotificationDictionary: userInfo as! [String : NSObject])!
        if ckNotification.notificationType == .query, // maybe .recordZone
            let queryNotification = ckNotification as? CKQueryNotification {
            let recordID = queryNotification.recordID
            return recordID
        }
        return nil
    }
}
