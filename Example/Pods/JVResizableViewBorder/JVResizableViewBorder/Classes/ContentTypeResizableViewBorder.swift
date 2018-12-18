import JVContentType

public struct ContentTypeResizableViewBorder: ContentType {

    public static var allTypes = Set<ContentTypeResizableViewBorder>()
    
    public var contentTypeId: String?
    public let lineWidth: CGFloat
    public var borderColor: CGColor
    
    public init(contentTypeId: String?, lineWidth: CGFloat, borderColor: CGColor) {
        self.contentTypeId = contentTypeId
        self.lineWidth = lineWidth
        self.borderColor = borderColor
    }
    
    public init(old: ContentTypeResizableViewBorder, newContentTypeId: String?) {
        self = old
        self.contentTypeId = newContentTypeId
    }

}
