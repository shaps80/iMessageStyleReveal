import UIKit

public final class RevealableTableViewBehaviour: NSObject {

    private var observer: NSKeyValueObservation?

    private weak var tableView: UITableView?
    private weak var tableViewDelegate: UITableViewDelegate?

    public init(tableView: UITableView) {
        self.tableView = tableView
        super.init()

        observer = tableView.observe(\.delegate, options: [.initial, .new]) { [weak self] tableView, _ in
            // we need to guard, otherwise if self is nil, we might also nil out the delegate
            guard let self = self else { return }
            // we need to prevent a loop here, because below we set the delegate back to ourselves which re-triggers this observation
            guard tableView.delegate !== self else { return }
            self.tableViewDelegate = tableView.delegate
            tableView.delegate = self
        }
    }

}

extension RevealableTableViewBehaviour: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableViewDelegate?.tableView?(tableView, willDisplay: cell, forRowAt: indexPath)
    }

    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableViewDelegate?.tableView?(tableView, didEndDisplaying: cell, forRowAt: indexPath)
    }

}

// MARK: Delegate forwarding
extension RevealableTableViewBehaviour {

    public override func responds(to aSelector: Selector!) -> Bool {
        if super.responds(to: aSelector) { return true }
        if tableViewDelegate?.responds(to: aSelector) ?? false { return true }
        return false
    }

    public override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if super.responds(to: aSelector) { return self }
        return tableViewDelegate
    }

}
