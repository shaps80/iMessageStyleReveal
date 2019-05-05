import UIKit
import RevealableCell

final class TableViewCell: UITableViewCell {

    @IBOutlet private weak var messageLabel: UILabel!

    func apply(message: String) {
        messageLabel.text = message
    }

}

@IBDesignable
final class RoundedView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cornerRadius = 5
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        cornerRadius = 5
    }
    
}
