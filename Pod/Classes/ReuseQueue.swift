import UIKit

internal final class RevealableViewsReuseQueues: NSObject {

    fileprivate var queues: [String: RevealableViewsReuseQueue]

    internal func queueForIdentifier(_ identifier: String) -> RevealableViewsReuseQueue {
        var queue = queues[identifier]

        if queue == nil {
            queue = RevealableViewsReuseQueue(identifier: identifier)
            queues[identifier] = queue
        }

        return queue!
    }

    internal override init() {
        queues = [String: RevealableViewsReuseQueue]()
    }

}

internal final class RevealableViewsReuseQueue: NSObject {

    fileprivate var identifier: String
    fileprivate var views = [RevealableView]()

    fileprivate init(identifier: String) {
        self.identifier = identifier
    }

    internal func enqueue(_ view: RevealableView) {
        views.append(view)
    }

    internal func dequeueView() -> RevealableView? {
        guard views.count > 0 else {
            return nil
        }

        let view = views.first
        views.removeFirst()

        return view
    }

}
