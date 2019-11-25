import UIKit
import RevealableCell

extension ViewController: UITableViewDelegateRevealable {

    func tableView(_ tableView: UITableView, configurationForRevealableViewAt indexPath: IndexPath) -> RevealableViewConfiguration {
        let message = messages[indexPath.item]
        return RevealableViewConfiguration(type: TimestampView.self, style: message.style, dequeueSource: .nib) { view, indexPath in
            view.date = message.date as Date
        }
    }

    func tableView(_ tableView: UITableView, willDisplay revealableView: RevealableView, forRowAt indexPath: IndexPath) {
        guard indexPath.item == 0 else { return }
        print("will display revealable view")
    }

    func tableView(_ tableView: UITableView, didEndDisplaying revealableView: RevealableView, forRowAt indexPath: IndexPath) {
        guard indexPath.item == 0 else { return }
        print("did end displaying revealable view")
    }

}
