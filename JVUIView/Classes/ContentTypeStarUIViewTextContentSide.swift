import JVView
import JVGradientLayer
import JVConstraintEdges

open class ContentTypeJVUIViewTextContentSide: ContentTypeJVUIViewText {
    
    public var contentTypeJVUIViewSide: ContentTypeJVUIViewSide!
    public var contentIsOnLeftSide = true
    
    public init(contentTypeId: String?, contentTypeJVLabel: ContentTypeJVLabel, constraintEdges: ConstraintEdges, contentTypeJVUIViewSide: ContentTypeJVUIViewSide!, contentIsOnLeftSide: Bool) {
        self.contentTypeJVUIViewSide = contentTypeJVUIViewSide
        self.contentIsOnLeftSide = contentIsOnLeftSide
        
        super.init(contentTypeId: contentTypeId, contentTypeJVLabel: contentTypeJVLabel, constraintEdges: constraintEdges)
    }
    
    public required init(old: ContentTypeJVUIView, contentTypeId: String?) {
        super.init(old: old, contentTypeId: contentTypeId)
        
        contentTypeJVUIViewSide = (old as? ContentTypeJVUIViewTextContentSide)?.contentTypeJVUIViewSide?.copy()
        contentIsOnLeftSide = (old as? ContentTypeJVUIViewTextContentSide)?.contentIsOnLeftSide ?? true
    }
    
}
