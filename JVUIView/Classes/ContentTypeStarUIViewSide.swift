import JVView
import NVActivityIndicatorView
import JVConstraintEdges
import JVCurrentDevice
import JVContentType

public final class ContentTypeJVUIViewSide: ContentType, Copyable {
    
    public static var allTypes = Set<ContentTypeJVUIViewSide>()
    
    public var contentTypeId: String?
    public var constraintEdges: ConstraintEdges
    public var contentTypeJVUIViewSideContent: ContentTypeJVUIViewSideContent!
    
    public init(contentTypeId: String?, constraintEdges: ConstraintEdges, contentTypeJVUIViewSideContent: ContentTypeJVUIViewSideContent? = nil) {
        self.contentTypeId = contentTypeId
        self.constraintEdges = constraintEdges
        self.contentTypeJVUIViewSideContent = contentTypeJVUIViewSideContent
    }
    
    public required init(old: ContentTypeJVUIViewSide, contentTypeId: String?) {
        self.contentTypeId = contentTypeId
        constraintEdges = old.constraintEdges
        contentTypeJVUIViewSideContent = old.contentTypeJVUIViewSideContent?.copy()
    }
}

