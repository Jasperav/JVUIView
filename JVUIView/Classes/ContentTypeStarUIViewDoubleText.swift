import JVView
import JVConstraintEdges

/// Makes it possible to align 2 labels vertically.
/// e.g.:    [Max score:     1000]
/// The right label always has a higher compression
open class ContentTypeJVUIViewDoubleText: ContentTypeJVUIViewText {
    public var contentTypeJVLabelRight: ContentTypeJVLabel!
    
    public init(contentTypeId: String?, contentTypeJVLabelLeft: ContentTypeJVLabel?, contentTypeJVLabelRight: ContentTypeJVLabel?, constraintEdges: ConstraintEdges) {
        self.contentTypeJVLabelRight = contentTypeJVLabelRight
        
        super.init(contentTypeId: contentTypeId, contentTypeJVLabel: contentTypeJVLabelLeft, constraintEdges: constraintEdges)
    }
    
    public required init(old: ContentTypeJVUIView, contentTypeId: String?) {
        super.init(old: old, contentTypeId: contentTypeId)
        
        contentTypeJVLabelRight = (old as? ContentTypeJVUIViewDoubleText)?.contentTypeJVLabelRight
    }
}
