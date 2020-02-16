import UIKit

/// Declare a `Token` (e.g. in a `UIViewController`) when adding a `NotificationCenter` observer.
/// When the `Token` goes out of scope (e.g. `UIViewController` goes out of scope) the observer is
/// automatically removed from the `NotificationCenter`.
class Token {
    let token: NSObjectProtocol
    let center: NotificationCenter
    init(token: NSObjectProtocol, center: NotificationCenter) {
        self.token = token
        self.center = center
    }
    
    deinit {
        center.removeObserver(token)
    }
}

struct NotificationDescriptor<A> {
    let name: Notification.Name
    let convert: (Notification) -> A
}

struct CustomNotificationDescriptor<A> {
    let name: Notification.Name
}

extension CustomNotificationDescriptor {
    
    init(nameString: String) {
        self.name = Notification.Name(nameString)
    }
}

extension NotificationCenter {
    func addObserver<A>(descriptor: NotificationDescriptor<A>, using block: @escaping (A) -> ()) -> Token {
        let token = addObserver(forName: descriptor.name, object: nil, queue: nil, using: { note in
            block(descriptor.convert(note))
        })
        return Token(token: token, center: self)
    }

    func addObserver<A>(descriptor: CustomNotificationDescriptor<A>, queue: OperationQueue? = nil, using block: @escaping (A?) -> ()) -> Token {
        let token = addObserver(forName: descriptor.name, object: nil, queue: queue, using: { note in
            block(note.object as? A)
        })
        return Token(token: token, center: self)
    }
    
    func post<A>(descriptor: CustomNotificationDescriptor<A>, value: A? = nil) {
        post(name: descriptor.name, object: value)
    }
}
