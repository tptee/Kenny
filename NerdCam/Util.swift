import UIKit

extension CALayer {
    convenience init(contents: AnyObject?, contentsGravity: String) {
        self.init()
        self.contents = contents
        self.contentsGravity = contentsGravity
    }
}
