import UIKit
import JVView
import JVConstraintEdges
import JVCurrentDevice
import JVUIViewExtensions
import JVGradientLayer
import JVFontUtils

/// JV UIView with a label or button. The label can be a counter as well
open class JVUIViewText: JVUIView {
    
    var contentTypeText: ContentTypeJVUIViewText!
    
    public var label: JVLabel!
    
    /// Implicitly unwrapped but it is not always a counter
    public var countLabel: JVLabelCounter {
        get {
            return label as! JVLabelCounter
        }
    }
    
    // We override the minimum width and set it on the label.
    // In some cases, the label is still nil, we need to wait till the label is not nil.
    private var minimumWidthConstant: CGFloat?
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayerOnButtonTouchDown?.frame = bounds
    }
    
    public static func getWidth(contentType: ContentTypeJVUIViewText) -> CGFloat {
        let contentTypeLabel = contentType.contentTypeJVLabel!
        
        let textWidth = ContentTypeJVLabel.getSizeText(contentTypeLabel: contentTypeLabel).width
        let textEdges = contentType.constraintEdges.width
        let minimumConstraintConstant = JVUIView.getWidth(contentType: contentType)
        
        let textWidthToUse = max(textWidth, minimumConstraintConstant)
        
        return ceil(textWidthToUse + textEdges)
    }
    
    public class func getHeight(contentType: ContentTypeJVUIViewText) -> CGFloat {
        let contentTypeLabel = contentType.contentTypeJVLabel!
        
        let textHeight = ContentTypeJVLabel.getSizeText(contentTypeLabel: contentTypeLabel).height
        let textEdges = contentType.constraintEdges.height
        
        return ceil(textHeight + textEdges)
    }
    
    public override var width: CGFloat {
        get {
            if minimumWidthConstraint == nil {
                return label.width + contentTypeText.constraintEdges.width
            } else {
                let extraWidth = minimumWidthConstraint.constant - label.width
                if extraWidth > 0 {
                    return extraWidth + label.width  + contentTypeText.constraintEdges.width
                } else {
                    return minimumWidthConstraint.constant - label.width  + contentTypeText.constraintEdges.width
                }
            }
        }
    }
    
    public override var height: CGFloat {
        get {
            return label.height + contentTypeText.constraintEdges.height
        }
    }
    
    open override func setContentType() {
        super.setContentType()
        contentTypeText = contentType as! ContentTypeJVUIViewText
        setupText()
        
        guard let constant = minimumWidthConstant else { return }
        
        minimumWidthConstraint = NSLayoutConstraint(item: label,
                                                    attribute: .width,
                                                    relatedBy: .greaterThanOrEqual,
                                                    toItem: nil,
                                                    attribute: .notAnAttribute,
                                                    multiplier: 1,
                                                    constant: constant)
        minimumWidthConstraint.isActive = true
    }
    
    internal func setupText() {
        label = JVLabelUtils.dynamicInit(contentType: contentTypeText.contentTypeJVLabel)
        setConstraintsOnLabel()
        
        if button != nil {
            button.viewToAnimate = label
        }
    }
    
    internal func resetContentHuggingAndCompression() {
        label.setHuggingAndCompression(to: 249)
    }
    
    internal func getEdgesText() -> ConstraintEdges {
        return contentTypeText.constraintEdges
    }
    
    internal func setConstraintsOnLabel() {
        let edges = getEdgesText()
        label.setContentHugging(to: 949)
        label.setCompressionResistance(to: 950)
        label.fill(toSuperview: contentView, edges: edges)
    }
    
    public override func setMinimumWidth(constant: CGFloat) {
        minimumWidthConstant = constant
    }
    
}
