import UIKit
import JVCurrentDevice

open class ResizableViewBorder: UIView {
    
    @IBInspectable var contentTypeUIRectEdgesId: String = "" {
        didSet {
            self.contentTypeRectEdges = contentTypeUIRectEdgesId.contentTypeUIRectEdges
        }
    }
    
    @IBInspectable var contentTypeResizableViewBorderId: String = "" {
        didSet {
            self.contentTypeResizableViewBorder = contentTypeResizableViewBorderId.contentTypeResizableViewBorder
        }
    }
    
    public var contentTypeResizableViewBorder: ContentTypeResizableViewBorder!
    public var contentTypeRectEdges: ContentTypeUIRectEdges!
    public var didLayout = false
    
    public init(contentTypeResizableViewBorder: ContentTypeResizableViewBorder, contentTypeRectEdges: ContentTypeUIRectEdges) {
        self.contentTypeResizableViewBorder = contentTypeResizableViewBorder
        self.contentTypeRectEdges = contentTypeRectEdges
        super.init(frame: CGRect.zero)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        didLayout = true
        setNeedsDisplay()
    }
    
    open override func draw(_ rect: CGRect) {
        guard didLayout else { return }
        let edges = contentTypeRectEdges.edges
        let lineWidth = contentTypeResizableViewBorder.lineWidth
        
        if edges.contains(.top) || edges.contains(.all) {
            addBezierPath(paths: [
                CGPoint(x: 0, y: 0 + lineWidth / 2),
                CGPoint(x: self.bounds.width, y: 0 + lineWidth / 2)
                ])
        }
        
        if edges.contains(.bottom) || edges.contains(.all) {
            addBezierPath(paths: [
                CGPoint(x: 0, y: self.bounds.height - lineWidth / 2),
                CGPoint(x: self.bounds.width, y: self.bounds.height - lineWidth / 2)
                ])
        }
        
        if (edges.contains(.left) || edges.contains(.all) || edges.contains(.right)) && CurrentDevice.isRightToLeftLanguage{
            addBezierPath(paths: [
                CGPoint(x: 0 + lineWidth / 2, y: 0),
                CGPoint(x: 0 + lineWidth / 2, y: self.bounds.height)
                ])
        }
        
        if (edges.contains(.right) || edges.contains(.all) || edges.contains(.left)) && CurrentDevice.isRightToLeftLanguage{
            addBezierPath(paths: [
                CGPoint(x: self.bounds.width - lineWidth / 2, y: 0),
                CGPoint(x: self.bounds.width - lineWidth / 2, y: self.bounds.height)
                ])
        }
    }
    
    private func addBezierPath(paths: [CGPoint]) {
        let lineWidth = contentTypeResizableViewBorder.lineWidth
        let borderColor = contentTypeResizableViewBorder.borderColor
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        UIColor(cgColor: borderColor).setStroke()
        UIColor.blue.setFill()
        var didAddedFirstLine = false
        for singlePath in paths {
            if !didAddedFirstLine {
                didAddedFirstLine = true
                path.move(to: singlePath)
            } else {
                path.addLine(to: singlePath)
            }
        }
        path.stroke()
    }
}
