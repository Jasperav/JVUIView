import JVView
import JVGradientLayer
import JVConstraintEdges

open class ContentTypeJVUIViewTextContentBothSides: ContentTypeJVUIViewTextContentSide {
    
    public var contentTypeJVUIViewSideOpposite: ContentTypeJVUIViewSide!
    
    // contentTypeJVUIViewSide is implicitly unwrapped because of the gem/coin view
    public init(contentTypeId: String?, contentTypeJVLabel: ContentTypeJVLabel, constraintEdges: ConstraintEdges, contentTypeJVUIViewSide: ContentTypeJVUIViewSide!, contentIsOnLeftSide: Bool, contentTypeJVUIViewSideOpposite: ContentTypeJVUIViewSide!) {
        self.contentTypeJVUIViewSideOpposite = contentTypeJVUIViewSideOpposite
        
        super.init(contentTypeId: contentTypeId, contentTypeJVLabel: contentTypeJVLabel, constraintEdges: constraintEdges, contentTypeJVUIViewSide: contentTypeJVUIViewSide, contentIsOnLeftSide: contentIsOnLeftSide)
    }
    
    public required init(old: ContentTypeJVUIView, contentTypeId: String?) {
        super.init(old: old, contentTypeId: contentTypeId)
        
        contentTypeJVUIViewSideOpposite = (old as? ContentTypeJVUIViewTextContentBothSides)?.contentTypeJVUIViewSideOpposite?.copy()
    }

}
