# SwiftyNotification
A type-safe approach to NSNotification

## Installation

For now you may simply add `SwiftyNotification.swift` to your project. CocoaPods and Carthage support coming.

## Usage

### 1. Preparation

For each `NSNotification` name you wish to observe, you need to define a static class that conforms to the `Notification` protocol. This class should have a `static let name:String` holding the notification name, and a `static func parameters(note:NSNotification) throws -> P` (where `P` is an arbitrary type) that extracts and returns parameters from a `NSNotification`'s properties.

For example, if you will be registering observers for `UIKeyboardDidShowNotification`, you may do:

```swift
final class KeyboardAppeared: Notification {
    static let name = UIKeyboardDidShowNotification
    static func parameters(note: NSNotification) throws -> (beginFrame:CGRect,endFrame:CGRect) {
        let beginFrame = (note.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() ?? CGRectNull
        let endFrame = (note.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() ?? CGRectNull
        return (beginFrame,endFrame)
    }
}
```

### 2. Registering Observers

You may register an observer like in the example below (where the observer is `self`). There is no need to unregister, as this is done automatically once `self` is released from memory.

```swift
KeyboardAppeared.register(self) {
    innerSelf,params in
    innerSelf.keyboardAppeared(from:params.beginFrame,to:params.endFrame)
}
```

### 3. Unregistering Observers (Optional)

The `register` static method of `Notification` actually returns a `NotificationToken`. You may store this token anywhere and unregister the closure by doing `token.cancel()`.

### 4. Posting Notifications (Optional)

You may post notifications using `MyNotificationClass.post(parameters)`. But before this you need to implement `static func note(parameters:P) throws -> NSNotification`, a function that generates the corresponding `NSNotification` from parameters.

Although it does not make sense to manually post a keyboard notification, the `KeyboardAppeared` class above may be extended as follows to allow manual posting:

```swift
final class KeyboardAppeared: Notification {
    static let name = UIKeyboardDidShowNotification
    static func parameters(note: NSNotification) throws -> (beginFrame:CGRect,endFrame:CGRect) {
        let beginFrame = (note.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() ?? CGRectNull
        let endFrame = (note.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() ?? CGRectNull
        return (beginFrame,endFrame)
    }
    static func note(parameters:(beginFrame:CGRect,endFrame:CGRect)) throws -> NSNotification {
        return NSNotification(
            name: name,
            object: nil,
            userInfo: [
                UIKeyboardFrameBeginUserInfoKey:NSValue(CGRect: params.beginFrame),
                UIKeyboardFrameEndUserInfoKey:NSValue(CGRect: params.endFrame)
            ]
        )
    }
}
```

