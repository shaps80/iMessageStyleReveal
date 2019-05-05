import UIKit
import RevealableCell

final class TimestampView: RevealableView {

    @IBOutlet private weak var titleLabel: UILabel!

    var date = Date() {
        didSet { titleLabel.text = dateFormatter.string(from: self.date) }
    }

    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }

}
