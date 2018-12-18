import UIKit

open class ShapeDiamond: Shape {
    
    public init(frame: CGRect,
                borderWidth: CGFloat,
                fillColor: UIColor,
                borderColor: UIColor,
                contentTypeColorChanger: ContentTypeColorChanger?) {
        super.init(frame: frame, borderWidth: borderWidth, fillColor: fillColor, borderColor: borderColor, contentTypeColorChanger: contentTypeColorChanger, contentType: .diamond)
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func determinePath(frame: CGRect) -> CGPath {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: self.bounds.width / 2,
                              y: 0))
        
        path.addLine(to: CGPoint(x: self.bounds.width * 0.85,
                                 y: self.bounds.height / 2))
        
        path.addLine(to: CGPoint(x: self.bounds.width / 2,
                                 y: self.bounds.height))
        
        path.addLine(to: CGPoint(x: self.bounds.width * 0.15,
                                 y: self.bounds.height / 2))
        
        path.close()
        
        return path.cgPath
    }
}
