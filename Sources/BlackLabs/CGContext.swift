import UIKit

public extension CGContext {
    
    func drawLine(_ strokeWidth:CGFloat, x:CGFloat, y:CGFloat, x1:CGFloat, y1:CGFloat) {
        self.setLineWidth(strokeWidth)
        self.move(to: CGPoint(x: x, y: y))
        self.addLine(to: CGPoint(x: x1, y: y1))
        self.strokePath()
    }
    
    func drawText(_ text:String, maxTextRect:CGRect, attrsDictionary:[String : AnyObject]) {
        let attrString = NSAttributedString.init(string: text, attributes: convertToOptionalNSAttributedStringKeyDictionary(attrsDictionary))
        let strRect = attrString.boundingRect(with: maxTextRect.size, options: .usesLineFragmentOrigin, context: nil)
        let centeredRect = CGRect(x: maxTextRect.minX + ((maxTextRect.width - strRect.width) * 0.5)
            , y: maxTextRect.minY + ((maxTextRect.height - strRect.height) * 0.5)
            , width: strRect.width
            , height: strRect.height)
        attrString.draw(with: centeredRect, options: .usesLineFragmentOrigin, context: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
