import UIKit

/// Defines which edge of the cell the view will be placed alongside
public enum RevealPosition {
    /// The view will be aligned alongside the leading edge of the cell
    case leading
    /// The view will be aligned alongside the trailing edge of the cell
    case trailing
}

/// Defines the style used for showing a revealable view
public enum RevealStyle {
    /// The cell will be moved out-of-the-way to accommodate the view
    case slide
    /// The cell will remain in-place and the view will be shown over it
    case over
}

/// Defines a configuration for a revealable view
public final class RevealableViewConfiguration: NSObject {

    /// Defines the various source's for loading a revealableView
    public enum Source {
        /// The view should be loaded via a XIB
        case nib
        /// The view should be loaded via init(frame:)
        case `class`
    }

    internal let viewType: RevealableView.Type
    internal let style: RevealStyle
    internal let configure: (RevealableView, IndexPath) -> Void
    internal let dequeueSource: Source
    internal var reuseIdentifier: String {
        return String(describing: viewType)
    }

    // this is a temporary cached version that's set only while its on screen, otherwise this returns nil
    internal weak var revealableView: RevealableView?

    public init<View>(type: View.Type, style: RevealStyle, dequeueSource: Source, configure: @escaping (View, IndexPath) -> Void) where View: RevealableView {
        self.viewType = View.self
        self.style = style
        self.dequeueSource = dequeueSource

        self.configure = { view, indexPath in
            configure(view as! View, indexPath)
        }

        super.init()
    }

}

/// Provides additional methods for providing revealableView's in your tableView
@objc public protocol UITableViewDelegateRevealable: UITableViewDelegate {

    /// Return a view here to have it presented alongside your cell when the user pans
    ///
    /// - Parameters:
    ///   - tableView: The tableView that will host this view
    ///   - indexPath: The indexPath of the cell that this view will be shown alongside
    /// - Returns: A `RevealableView` subclass that will be displayed alongside of the cell
    @objc optional func tableView(_ tableView: UITableView, configurationForRevealableViewAt indexPath: IndexPath) -> RevealableViewConfiguration

    /// Called when the user begins the pan gesture, before the revealable view is shown
    ///
    /// - Parameters:
    ///   - tableView: The tableView that will host this view
    ///   - revealableView: The revealable view that will be shown
    ///   - indexPath: The indexPath of the cell this view is being shown alongside
    @objc optional func tableView(_ tableView: UITableView, willDisplay revealableView: RevealableView, forRowAt indexPath: IndexPath)

    /// Called when the user ends the pan gesture, after the revealable view is hidden
    ///
    /// - Parameters:
    ///   - tableView: The tableView that will host this view
    ///   - revealableView: The revealable view that will be hidden
    ///   - indexPath: The indexPath of the cell this view is being shown alongside
    @objc optional func tableView(_ tableView: UITableView, didEndDisplaying revealableView: RevealableView, forRowAt indexPath: IndexPath)

}
