import UIKit

extension CALayer {
    convenience init(contents: AnyObject?, contentsGravity: String) {
        self.init()
        self.contents = contents
        self.contentsGravity = contentsGravity
    }
}

extension UILabel {
    convenience init(
        frame: CGRect,
        text: String,
        textAlignment: NSTextAlignment,
        textColor: UIColor,
        backgroundColor: UIColor
    ) {
        self.init(frame: frame)
        self.text = text
        self.textAlignment = textAlignment
        self.textColor = textColor
        self.backgroundColor = backgroundColor
    }
}