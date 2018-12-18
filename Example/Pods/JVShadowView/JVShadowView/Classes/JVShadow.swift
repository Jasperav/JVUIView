import UIKit

public class JVShadow {
    
    public static func applyShadow(toLayer layer: CALayer, contentType: ContentTypeJVShadowView) {
        layer.shadowColor = contentType.color
        layer.shadowRadius = contentType.radius
        layer.shadowOffset = contentType.offSet
        layer.shadowOpacity = contentType.opacity
        layer.shadowPath = UIBezierPath(roundedRect: CGRect.zero, cornerRadius: 0).cgPath // Increases performances? :P
    }
    
    public static func updateShadowPath(toLayer layer: CALayer, bounds: CGRect, contentType: ContentTypeJVShadowView) {
        layer.shadowPath = UIBezierPath(roundedRect: bounds.enlarged(by: contentType.enlargeBoundsByAbsoluteValue, bounds: bounds), cornerRadius: contentType.radius).cgPath
    }
    
}

public extension CGRect {
    func enlarged(by: CGFloat, bounds: CGRect) -> CGRect {
        let currentSize = bounds.size
        let correctedSize = CGSize(width: currentSize.width + by,
                                   height: currentSize.height + by)
        return CGRect(x: bounds.minX - ((correctedSize.width - currentSize.width) / 2),
                      y: bounds.minY - ((correctedSize.height - currentSize.height) / 2),
                      width: correctedSize.width,
                      height: correctedSize.height)
    }
}
