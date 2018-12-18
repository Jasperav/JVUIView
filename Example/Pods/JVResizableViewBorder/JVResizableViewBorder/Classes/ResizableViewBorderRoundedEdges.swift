import UIKit

open class ResizableViewBorderRoundedEdges: UIView {
    
    @IBInspectable var contentTypeResizableViewBorderRoundedEdgesId: String = "" {
        didSet {
            self.contentTypeResizableViewBorderRoundedEdges = contentTypeResizableViewBorderRoundedEdgesId.contentTypeResizableViewBorderRoundedEdges
        }
    }
    
    @IBInspectable var contentTypeResizableViewBorderId: String = "" {
        didSet {
            self.contentTypeResizableViewBorder = contentTypeResizableViewBorderId.contentTypeResizableViewBorder
        }
    }
    
    public var contentTypeResizableViewBorder: ContentTypeResizableViewBorder!
    public var contentTypeResizableViewBorderRoundedEdges: ContentTypeResizableViewBorderRoundedEdges!
    public var didLayout = false
    
    public init(contentTypeResizableViewBorder: ContentTypeResizableViewBorder, contentTypeResizableViewBorderRoundedEdges: ContentTypeResizableViewBorderRoundedEdges) {
        self.contentTypeResizableViewBorder = contentTypeResizableViewBorder
        self.contentTypeResizableViewBorderRoundedEdges = contentTypeResizableViewBorderRoundedEdges
        super.init(frame: CGRect.zero)
        backgroundColor = .clear
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        didLayout = true
        setNeedsDisplay()
    }
    
    public func getCornerMask() -> CACornerMask {
        var cornerMasks = CACornerMask()
        
        if contentTypeResizableViewBorderRoundedEdges.addBorderTop && contentTypeResizableViewBorderRoundedEdges.addBorderRight {
            cornerMasks.insert(.layerMaxXMinYCorner)
        }
        
        if contentTypeResizableViewBorderRoundedEdges.addBorderRight && contentTypeResizableViewBorderRoundedEdges.addBorderBottom {
            cornerMasks.insert(.layerMaxXMaxYCorner)
        }
        
        if contentTypeResizableViewBorderRoundedEdges.addBorderBottom && contentTypeResizableViewBorderRoundedEdges.addBorderLeft {
            cornerMasks.insert(.layerMinXMaxYCorner)
        }
        
        if contentTypeResizableViewBorderRoundedEdges.addBorderLeft && contentTypeResizableViewBorderRoundedEdges.addBorderTop {
            cornerMasks.insert(.layerMinXMinYCorner)
        }
        
        return cornerMasks
    }
    
    public func getCornerRadius() -> CGFloat {
        let lineWidth = contentTypeResizableViewBorder.lineWidth
        let cornerRadius = contentTypeResizableViewBorderRoundedEdges.cornerRadius
        return cornerRadius - lineWidth
    }
    
    open override func draw(_ rect: CGRect) {
        guard didLayout else { return }
        
        /// Triggers an assertion error when trying to round every corner
        /// I do this because for sure setting the cornerradius on the layer itself is more efficient.
        assert(!(contentTypeResizableViewBorderRoundedEdges.addBorderBottom && contentTypeResizableViewBorderRoundedEdges.addBorderLeft && contentTypeResizableViewBorderRoundedEdges.addBorderTop && contentTypeResizableViewBorderRoundedEdges.addBorderRight))
        let lineWidth = contentTypeResizableViewBorder.lineWidth
        let cornerRadius = contentTypeResizableViewBorderRoundedEdges.cornerRadius
        let innerRect = self.bounds.insetBy(dx: lineWidth / 2, dy: lineWidth / 2)
        UIColor(cgColor: contentTypeResizableViewBorder.borderColor).setStroke()
        
        var path: UIBezierPath! = UIBezierPath()
        path.lineWidth = lineWidth
        
        var pathDidMove = false
        var createNewPath = false
        
        if contentTypeResizableViewBorderRoundedEdges.addBorderTop {
            let startX = contentTypeResizableViewBorderRoundedEdges.addBorderLeft ? cornerRadius : -innerRect.minX
            let endX = innerRect.maxX - (contentTypeResizableViewBorderRoundedEdges.addBorderRight ? cornerRadius : -innerRect.minX)
            let startY = innerRect.minY
            let endY = innerRect.minY
            path.move(to: CGPoint(x: startX, y: startY))
            path.addLine(to: CGPoint(x: endX, y: endY))
            pathDidMove = true
            
            if contentTypeResizableViewBorderRoundedEdges.addBorderRight {
                let _endX = innerRect.maxX
                let _startX = innerRect.maxX
                let _endY = innerRect.minY + contentTypeResizableViewBorderRoundedEdges.cornerRadius
                let _startY = innerRect.minY
                path.addQuadCurve(to: CGPoint(x: _endX, y: _endY), controlPoint: CGPoint(x: _startX, y: _startY))
            }
            
            if !contentTypeResizableViewBorderRoundedEdges.addBorderRight {
                path.stroke()
                path = nil
                createNewPath = true
            }
        } else if !contentTypeResizableViewBorderRoundedEdges.addBorderRight && path != nil {
            path.stroke()
            path = nil
            createNewPath = true
        }
        
        if contentTypeResizableViewBorderRoundedEdges.addBorderRight {
            if createNewPath {
                path = UIBezierPath()
                path.lineWidth = lineWidth
                pathDidMove = false
            }
            let startX = innerRect.maxX
            let endX = innerRect.maxX
            let startY = contentTypeResizableViewBorderRoundedEdges.addBorderTop ? cornerRadius : -innerRect.minY
            let endY = innerRect.maxY - (contentTypeResizableViewBorderRoundedEdges.addBorderBottom ? cornerRadius : -cornerRadius)
            if !pathDidMove {
                path.move(to: CGPoint(x: startX, y: startY))
            }
            path.addLine(to: CGPoint(x: endX, y: endY))
            pathDidMove = true
            
            if contentTypeResizableViewBorderRoundedEdges.addBorderBottom {
                let _endX = innerRect.maxX - cornerRadius
                let _startX = innerRect.maxX
                let _endY = innerRect.maxY
                let _startY = innerRect.maxY
                path.addQuadCurve(to: CGPoint(x: _endX, y: _endY), controlPoint: CGPoint(x: _startX, y: _startY))
            }
            
            if !contentTypeResizableViewBorderRoundedEdges.addBorderBottom {
                path.stroke()
                path = nil
                createNewPath = true
            }
        } else if !contentTypeResizableViewBorderRoundedEdges.addBorderBottom && path != nil {
            path.stroke()
            path = nil
            createNewPath = true
        }
        
        if contentTypeResizableViewBorderRoundedEdges.addBorderBottom {
            if createNewPath {
                path = UIBezierPath()
                path.lineWidth = lineWidth
                pathDidMove = false
            }
            let startX = innerRect.maxX - (contentTypeResizableViewBorderRoundedEdges.addBorderRight ? cornerRadius : -innerRect.minX)
            let endX = contentTypeResizableViewBorderRoundedEdges.addBorderLeft ? cornerRadius : -innerRect.minX
            let startY = innerRect.maxY
            let endY = innerRect.maxY
            if !pathDidMove {
                path.move(to: CGPoint(x: startX, y: startY))
            }
            path.addLine(to: CGPoint(x: endX, y: endY))
            pathDidMove = true
            
            if contentTypeResizableViewBorderRoundedEdges.addBorderLeft {
                let _endX = innerRect.minX
                let _startX = innerRect.minX
                let _endY = innerRect.maxY - cornerRadius
                let _startY = innerRect.maxY
                path.addQuadCurve(to: CGPoint(x: _endX, y: _endY), controlPoint: CGPoint(x: _startX, y: _startY))
            }
            
            if !contentTypeResizableViewBorderRoundedEdges.addBorderLeft {
                path.stroke()
                path = nil
                createNewPath = true
            }
        } else if !contentTypeResizableViewBorderRoundedEdges.addBorderLeft && path != nil {
            path.stroke()
            path = nil
            createNewPath = true
        }
        
        if contentTypeResizableViewBorderRoundedEdges.addBorderLeft {
            if createNewPath {
                path = UIBezierPath()
                path.lineWidth = lineWidth
                pathDidMove = false
            }
            let startX = innerRect.minX
            let endX = innerRect.minX
            let startY = innerRect.maxY - (contentTypeResizableViewBorderRoundedEdges.addBorderBottom ? cornerRadius : -innerRect.minY)
            let endY = contentTypeResizableViewBorderRoundedEdges.addBorderTop ? cornerRadius : -innerRect.minY
            if !pathDidMove {
                path.move(to: CGPoint(x: startX, y: startY))
            }
            path.addLine(to: CGPoint(x: endX, y: endY))
            pathDidMove = true
            
            if contentTypeResizableViewBorderRoundedEdges.addBorderTop {
                let _endX = innerRect.minX + cornerRadius
                let _startX = innerRect.minX
                let _endY = innerRect.minY
                let _startY = innerRect.minY
                path.addQuadCurve(to: CGPoint(x: _endX, y: _endY), controlPoint: CGPoint(x: _startX, y: _startY))
            }
            
            path.stroke()
        }
    }
    
}
