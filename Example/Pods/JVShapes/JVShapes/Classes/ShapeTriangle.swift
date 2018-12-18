import UIKit

open class ShapeTriangle: Shape {
    
    public init(frame: CGRect,
                borderWidth: CGFloat,
                fillColor: UIColor,
                borderColor: UIColor,
                contentTypeColorChanger: ContentTypeColorChanger?) {
        super.init(frame: frame, borderWidth: borderWidth, fillColor: fillColor, borderColor: borderColor, contentTypeColorChanger: contentTypeColorChanger, contentType: .triangle)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func determinePath(frame: CGRect) -> CGPath {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: bounds.width / 2,
                              y: 0))
        path.addLine(to: CGPoint(x: bounds.width,
                                 y: bounds.height))
        path.addLine(to: CGPoint(x: 0,
                                 y: bounds.height))
        
        path.close()
        
        return path.cgPath
    }
    
}
