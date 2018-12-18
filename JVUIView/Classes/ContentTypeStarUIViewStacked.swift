public final class ContentTypeJVUIViewStacked: ContentTypeJVUIView {
    
    public var contentTypesJVUIView: [ContentTypeJVUIView]
    public var distribution: UIStackViewDistribution
    public var axis: UILayoutConstraintAxis
    public var spacingBetweenViews: CGFloat
    
    public init(contentTypeId: String?, contentTypesJVUIView: [ContentTypeJVUIView], distribution: UIStackViewDistribution, axis: UILayoutConstraintAxis, spacingBetweenViews: CGFloat) {
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
