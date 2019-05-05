import Foundation
import RevealableCell

final class Message {

    let text: String
    let date: Date
    let style: RevealStyle

    init(style: RevealStyle, date: Date, text: String) {
        self.text = text
        self.style = style
        self.date = date
    }

}
