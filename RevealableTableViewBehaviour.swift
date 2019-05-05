import UIKit

public final class RevealableTableViewBehaviour: NSObject {

    private var observer: NSKeyValueObservation?
    private weak var tableViewDelegate: UITableViewDelegate?
    private let reuseQueues = RevealableViewsReuseQueues()
    public let position: RevealPosition
    private var cachedConfigs: [IndexPath: RevealableViewConfiguration] = [:]

    public init(position: RevealPosition, tableView: UITableView) {
        self.position = position
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

    private func willShowCell(_ cell: UITableViewCell, in tableView: UITableView, at indexPath: IndexPath) {
        guard let delegate = tableViewDelegate as? UITableViewDelegateRevealable else { return }
        guard let config = cachedConfigs[indexPath] ?? delegate.tableView?(tableView, configurationForRevealableViewAt: indexPath) else { return }

        let queue = reuseQueues.queueForIdentifier(config.reuseIdentifier)

        func prepare(view: RevealableView, for cell: UITableViewCell, at indexPath: IndexPath, with config: RevealableViewConfiguration) {
            config.revealableView = view
            cell.addSubview(view)

            let constraint = position == .leading
                ? view.leadingAnchor.constraint(equalTo: cell.trailingAnchor)
                : view.trailingAnchor.constraint(equalTo: cell.leadingAnchor)

            view.translatesAutoresizingMaskIntoConstraints = false
            view.setContentHuggingPriority(.required, for: .vertical)
            view.setContentCompressionResistancePriority(.required, for: .vertical)
            view.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
            view.setContentCompressionResistancePriority(.fittingSizeLevel, for: .horizontal)

            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: cell.topAnchor),
                view.bottomAnchor.constraint(equalTo: cell.bottomAnchor),
                constraint
            ])

            config.configure(view, indexPath)
            cachedConfigs[indexPath] = config
        }

        if let view = config.revealableView ?? queue.dequeueView() {
            prepare(view: view, for: cell, at: indexPath, with: config)
            return
        }

        switch config.dequeueSource {
        case .class:
            let view = config.viewType.init()
            prepare(view: view, for: cell, at: indexPath, with: config)
        case .nib:
            let nibName = String(describing: config.viewType)
            let bundle = Bundle(for: config.viewType)
            let nib = UINib(nibName: nibName, bundle: bundle)
                .instantiate(withOwner: nil, options: nil)

            guard let view = nib.first as? RevealableView else {
                debugPrint("The nib: '\(nibName)' should contain a single view that is a subclass of `RevealableView`")
                return
            }

            prepare(view: view, for: cell, at: indexPath, with: config)
        }
    }

    private func didHideCell(_ cell: UITableViewCell, in tableView: UITableView, at indexPath: IndexPath) {
        guard let config = cachedConfigs[indexPath] else { return }
        guard let view = config.revealableView else { return }
        let queue = reuseQueues.queueForIdentifier(config.reuseIdentifier)

        view.prepareForReuse()
        view.removeFromSuperview()
        queue.enqueue(view)

        config.revealableView = nil
        cachedConfigs[indexPath] = nil
    }

}

extension RevealableTableViewBehaviour: UITableViewDelegate {

    @objc public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableViewDelegate?.tableView?(tableView, willDisplay: cell, forRowAt: indexPath)
        willShowCell(cell, in: tableView, at: indexPath)
    }

    @objc public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableViewDelegate?.tableView?(tableView, didEndDisplaying: cell, forRowAt: indexPath)
        didHideCell(cell, in: tableView, at: indexPath)
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
