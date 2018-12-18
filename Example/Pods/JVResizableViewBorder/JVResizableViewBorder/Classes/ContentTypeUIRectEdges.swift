import JVContentType

public struct ContentTypeUIRectEdges: ContentType {

    public static var allTypes = Set<ContentTypeUIRectEdges>()
    
    public var contentTypeId: String?
    public let edges: UIRectEdge
    
    public init(contentTypeId: String?, edges: UIRectEdge) {
        self.contentTypeId = contentTypeId
        self.edges = edges
    }
    
    public init(old: ContentTypeUIRectEdges, newContentTypeId: String?) {
        self = old
        contentTypeId = newContentTypeId
    }
}
