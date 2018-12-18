import UIKit

open class JVUIViewStacked: JVUIView {
    
    var contentTypeStacked: ContentTypeJVUIViewStacked!
    
    public static func getWidth(contentType: ContentTypeJVUIViewStacked) -> CGFloat {
        var width: CGFloat = 0
        
        for contentTypeJVUIView in contentType.contentTypesJVUIView {
            let widthView = JVUIViewUtils.getWidth(contentTypeId: contentTypeJVUIView.contentTypeId!)
            
            if contentType.axis == .horizontal {
                 width += widthView
            } else {
                width = max(width, widthView)
            }
        }
        
        if contentType.axis == .horizontal {
            width += CGFloat(contentType.contentTypesJVUIView.count - 1) * contentType.spacingBetweenViews
        }
        
        return width
    }
    
    public static func getHeight(contentType: ContentTypeJVUIViewStacked) -> CGFloat {
        var height: CGFloat = 0
        
        for contentTypeJVUIView in contentType.contentTypesJVUIView {
            let heightView = JVUIViewUtils.getHeight(contentTypeId: contentTypeJVUIView.contentTypeId!)
            if contentType.axis == .vertical {
                height += heightView
            } else {
                height = max(height, heightView)
            }
        }
        
        if contentType.axis == .vertical {
            height += CGFloat(contentType.contentTypesJVUIView.count - 1) * contentType.spacingBetweenViews
        }
        
        return height
    }
    
    open override func setContentType() {
        super.setContentType()
        contentTypeStacked = contentType as! ContentTypeJVUIViewStacked
        var views = [UIView]()
        
        for contentTypeJVUIView in contentTypeStacked.contentTypesJVUIView {
            views.append(JVUIViewUtils.dynamicInit(contentType: contentTypeJVUIView))
        }
        
        let stackView = UIStackView(arrangedSubviews: views)
        
        stackView.fill(toSuperview: self)
        
        stackView.distribution = contentTypeStacked.distribution
        stackView.axis = contentTypeStacked.axis
        stackView.spacing = contentTypeStacked.spacingBetweenViews
        
        isUserInteractionEnabled = true
        stackView.isUserInteractionEnabled = true
    }
    
}
