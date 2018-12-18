import JVContentType

public struct ContentTypeResizableViewBorderRoundedEdges: ContentType {
    
    public static var allTypes = Set<ContentTypeResizableViewBorderRoundedEdges>()
    
    public var contentTypeId: String?
    public var cornerRadius: CGFloat
    public var addBorderTop: Bool
    public var addBorderRight: Bool
    public var addBorderBottom: Bool
    public var addBorderLeft: Bool
    
    public init(contentTypeId: String?, cornerRadius: CGFloat, addBorderTop: Bool, addBorderRight: Bool, addBorderBottom: Bool, addBorderLeft: Bool) {
        self.contentTypeId = contentTypeId
        self.cornerRadius = cornerRadius
        self.addBorderTop = addBorderTop
        self.addBorderRight = addBorderRight
        self.addBorderBottom = addBorderBottom
        self.addBorderLeft = addBorderLeft
    }
    
    public init(old: ContentTypeResizableViewBorderRoundedEdges, newContentTypeId: String? = nil) {
        self = old
        contentTypeId = newContentTypeId
    }

}
