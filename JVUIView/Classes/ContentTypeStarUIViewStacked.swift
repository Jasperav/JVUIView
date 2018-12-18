import UIKit

public final class ContentTypeJVUIViewStacked: ContentTypeJVUIView {
    
    public var contentTypesJVUIView: [ContentTypeJVUIView]
    public var distribution: UIStackView.Distribution
    public var axis: NSLayoutConstraint.Axis
    public var spacingBetweenViews: CGFloat
    
    public init(contentTypeId: String?, contentTypesJVUIView: [ContentTypeJVUIView], distribution: UIStackView.Distribution, axis: NSLayoutConstraint.Axis, spacingBetweenViews: CGFloat) {
        self.contentTypesJVUIView = contentTypesJVUIView
        self.distribution = distribution
        self.axis = axis
        self.spacingBetweenViews = spacingBetweenViews
        
        super.init(contentTypeId: contentTypeId)
        
        assert(contentTypesJVUIView.count > 1)
        assert(distribution == .fillEqually, "Currently only fill euqally is supported for the right widths and height")
    }
    
    public required init(old: ContentTypeJVUIView, contentTypeId: String?) {
        let old = old as! ContentTypeJVUIViewStacked
        
        contentTypesJVUIView = old.contentTypesJVUIView
        distribution = old.distribution
        axis = old.axis
        spacingBetweenViews = old.spacingBetweenViews
        
        super.init(old: old, contentTypeId: contentTypeId)
    }
    
    public required init(from decoder: Decoder) throws {
        fatalError()
    }
    
}
