import UIKit

open class ShapeSquare: Shape {
    
    public init(frame: CGRect,
                borderWidth: CGFloat,
                fillColor: UIColor,
                borderColor: UIColor,
                contentTypeColorChanger: ContentTypeColorChanger?) {
        super.init(frame: frame, borderWidth: borderWidth, fillColor: fillColor, borderColor: borderColor, contentTypeColorChanger: contentTypeColorChanger, contentType: .square)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func determinePath(frame: CGRect) -> CGPath {
        return UIBezierPath(rect: frame).cgPath
    }
    
}
