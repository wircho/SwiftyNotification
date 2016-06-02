//---

import Foundation

// MARK: Notification Protocol

public protocol Notification {
    associatedtype P
    static var name:String { get }
    static func note(params:P) throws -> NSNotification
    static func parameters(note:NSNotification) throws -> P
}

extension Notification {
    public static func note(params:P) throws -> NSNotification {
        throw NotificationError.MethodNotImplemented
    }
    public static func register<T:AnyObject>(listener:T, object:AnyObject? = nil, queue: NSOperationQueue? = nil, closure:(T,P)->Void) -> NotificationToken {
        var token:NotificationToken? = nil
        let observer = NSNotificationCenter.defaultCenter().addObserverForName(name, object: object, queue: queue) {
            note in
            guard let actualToken = token else { return }
            guard let listener = actualToken.listener as? T else {
                actualToken.cancel()
                token = nil
                return
            }
            guard let params = try? parameters(note) else { return }
            closure(listener,params)
        }
        token = NotificationToken(listener: listener, observer: observer)
        return token!
    }
    public static func post(params:P) throws -> Void {
        let note = try self.note(params)
        NSNotificationCenter.defaultCenter().postNotification(note)
    }
}

// MARK: Notification Token

public class NotificationToken {
    private weak var listener:AnyObject?
    private var observer:NSObjectProtocol?
    private init(listener:AnyObject, observer:NSObjectProtocol) {
        self.listener = listener
        self.observer = observer
    }
    deinit {
        self.cancel()
    }
    func cancel() {
        guard let observer = observer else { return }
        self.observer = nil
        NSNotificationCenter.defaultCenter().removeObserver(observer)
    }
}

// MARK: Notification Error

public enum NotificationError: ErrorType {
    case MethodNotImplemented
}
