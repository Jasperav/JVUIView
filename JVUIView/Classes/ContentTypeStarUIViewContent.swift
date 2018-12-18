public class ContentTypeJVUIViewContent: ContentTypeJVUIView {
    
    public var contentTypeJVUIViewContent: ContentTypeJVUIViewSide!
    
    public init(contentTypeId: String?, contentTypeJVUIViewContent: ContentTypeJVUIViewSide?) {
        self.contentTypeJVUIViewContent = contentTypeJVUIViewContent
        
        super.init(contentTypeId: contentTypeId)
    }
    
    public required init(old: ContentTypeJVUIView, contentTypeId: String?) {
        super.init(old: old, contentTypeId: contentTypeId)
        
        contentTypeJVUIViewContent = (old as? ContentTypeJVUIViewContent)?.contentTypeJVUIViewContent
    }
}
