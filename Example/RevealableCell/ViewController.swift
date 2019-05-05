import UIKit
import LoremIpsum
import RevealableCell

extension RevealStyle {
    var reuseIdentifier: String {
        switch self {
        case .over: return "leftAlignedCell"
        case .slide: return "rightAlignedCell"
        }
    }
}

class ViewController: UITableViewController {

    private var behaviour: RevealableTableViewBehaviour!
    internal var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        behaviour = RevealableTableViewBehaviour(position: .trailing, tableView: tableView)

        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }

        for i in 0..<1000 {
            let text = LoremIpsum.sentence()!
            let style: RevealStyle = i % 2 == 0 ? .over : .slide
            let date = Date(timeIntervalSinceNow: TimeInterval(i) * 60)
            let message = Message(style: style, date: date, text: text)
            messages.append(message)
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: message.style.reuseIdentifier , for: indexPath) as! TableViewCell
        cell.apply(message: message.text)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
}

extension ViewController {

//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        let controller = UIAlertController(title: "Welcome", message: "Swipe to the left to see it in action", preferredStyle: .alert)
//        controller.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//        present(controller, animated: true, completion:
    
}
