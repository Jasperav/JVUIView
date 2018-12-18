import UIKit

open class JVShadowView: UIView {
    
    @IBInspectable var contentTypeId: String = "" {
        didSet {
            contentType = contentTypeId.contentTypeJVShadowView
            applyShadow()
        }
    }
    
    private var contentType: ContentTypeJVShadowView!
    
    public init(contentType: ContentTypeJVShadowView) {
        super.init(frame: CGRect.zero)
        
        self.contentType = contentType
        applyShadow()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func applyShadow() {
        JVShadow.applyShadow(toLayer: layer, contentType: contentType)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        JVShadow.updateShadowPath(toLayer: layer, bounds: bounds, contentType: contentType)
    }
    
}
