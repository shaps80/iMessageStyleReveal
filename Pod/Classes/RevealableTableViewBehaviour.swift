import UIKit

public final class RevealableTableViewBehaviour: NSObject {

    private var delegateObserver: NSKeyValueObservation?
    private var offsetObserver: NSKeyValueObservation?

    private weak var tableViewDelegate: UITableViewDelegate?

    private let reuseQueues = RevealableViewsReuseQueues()
    public let position: RevealPosition
    private var cachedConfigs: [IndexPath: RevealableViewConfiguration] = [:]

    private var translationX: CGFloat = 0
    private var currentOffset: CGFloat = 0
    private lazy var panGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleRevealPan(_:)))
        gesture.delegate = self
        return gesture
    }()

    public init(position: RevealPosition, tableView: UITableView) {
        self.position = position
        super.init()

        delegateObserver = tableView.observe(\.delegate, options: [.initial, .new]) { [weak self] tableView, _ in
            // we need to guard, otherwise if self is nil, we might also nil out the delegate
            guard let self = self else { return }
            // we need to prevent a loop here, because below we set the delegate back to ourselves which re-triggers this observation
            guard tableView.delegate !== self else { return }
            self.tableViewDelegate = tableView.delegate
            tableView.delegate = self
        }

        tableView.addGestureRecognizer(panGesture)
    }

    private func willShowCell(_ cell: UITableViewCell, in tableView: UITableView, at indexPath: IndexPath) {
        guard let delegate = tableViewDelegate as? UITableViewDelegateRevealable else { return }
        guard let config = cachedConfigs[indexPath] ?? delegate.tableView?(tableView, configurationForRevealableViewAt: indexPath) else { return }

        let queue = reuseQueues.queueForIdentifier(config.reuseIdentifier)

        func prepare(view: RevealableView, for cell: UITableViewCell, at indexPath: IndexPath, with config: RevealableViewConfiguration) {
            config.revealableView = view
            config.configure(view, indexPath)
            cachedConfigs[indexPath] = config
            cell.addSubview(view)

            let constraint = position == .trailing
                ? view.leadingAnchor.constraint(equalTo: cell.contentView.trailingAnchor)
                : view.trailingAnchor.constraint(equalTo: cell.contentView.leadingAnchor)

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
        }

        if let view = config.revealableView ?? queue.dequeueView() {
            view.transform = .identity
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

extension RevealableTableViewBehaviour: UIGestureRecognizerDelegate {

    @objc private func handleRevealPan(_ gesture: UIPanGestureRecognizer) {
        guard let tableView = gesture.view as? UITableView else { return }

        switch gesture.state {
        case .began:
            break
        case .changed:
            translationX = gesture.translation(in: gesture.view).x
            currentOffset += translationX

            gesture.setTranslation(.zero, in: gesture.view)
            updateTransforms(in: tableView)
        default:
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.translationX = 0
                self.currentOffset = 0
                self.updateTransforms(in: tableView, transform: .identity)
            }, completion: nil)
        }
    }

    private func updateTransforms(in tableView: UITableView, transform: CGAffineTransform? = nil) {
        (tableView.indexPathsForVisibleRows ?? []).forEach {
            guard let cell = tableView.cellForRow(at: $0) else { return }
            guard let config = cachedConfigs[$0] else { return }
            guard let revealableView = config.revealableView else { return }
            updateTransform(transform: transform, cell: cell, config: config, revealableView: revealableView, indexPath: $0)
        }
    }

    fileprivate func updateTransform(transform: CGAffineTransform?, cell: UITableViewCell, config: RevealableViewConfiguration, revealableView: RevealableView, indexPath: IndexPath) {
        var x = currentOffset

        if position == .trailing {
            x = max(x, -revealableView.bounds.width)
            x = min(x, 0)
        } else {
            x = max(x, 0)
            x = min(x, revealableView.bounds.width)
        }

        let transformView = config.style == .slide
            ? cell.contentView
            : revealableView

        transformView.transform = transform ?? CGAffineTransform(translationX: x, y: 0)
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return [gestureRecognizer, otherGestureRecognizer].contains(panGesture)
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let gesture = gestureRecognizer as? UIPanGestureRecognizer, gesture == panGesture {
            let translation = gesture.translation(in: gesture.view)
            return (abs(translation.x) > abs(translation.y)) && (gesture == panGesture)
        }

        return true
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
        if tableViewDelegate?.responds(to: aSelector)
            ?? false { return true }
        return false
    }

    public override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if super.responds(to: aSelector) { return self }
        return tableViewDelegate
    }

}
