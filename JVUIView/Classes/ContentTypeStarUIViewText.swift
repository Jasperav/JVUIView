import JVView
import JVGradientLayer
import JVConstraintEdges

open class ContentTypeJVUIViewText: ContentTypeJVUIView {
    
    public var contentTypeJVLabel: ContentTypeJVLabel!
    public var constraintEdges: ConstraintEdges!
    
    public init(contentTypeId: String?, contentTypeJVLabel: ContentTypeJVLabel?, constraintEdges: ConstraintEdges) {
        self.contentTypeJVLabel = contentTypeJVLabel
        self.constraintEdges = constraintEdges
        
        super.init(contentTypeId: contentTypeId)
    }
    
    public required init(old: ContentTypeJVUIView, contentTypeId: String?) {
        super.init(old: old, contentTypeId: contentTypeId)
        
        contentTypeJVLabel = (old as? ContentTypeJVUIViewText)?.contentTypeJVLabel
        constraintEdges = (old as? ContentTypeJVUIViewText)?.constraintEdges
    }
    
}
