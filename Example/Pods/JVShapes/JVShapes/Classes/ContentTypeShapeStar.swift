import JVContentType

public struct ContentTypeShapeStar: ContentType {
    
    private static let defaultIdentifier = "default"
    
    public static var allTypes: Set = [
        ContentTypeShapeStar(contentTypeId: ContentTypeShapeStar.defaultIdentifier,
                             points: 5,
                             extrusion: 0.225)
    ]
    
    public var contentTypeId: String?
    public var points: Int
    public var extrusion: CGFloat
    
    public init(contentTypeId: String?, points: Int, extrusion: CGFloat) {
        self.contentTypeId = contentTypeId
        self.points = points
        self.extrusion = extrusion
    }
    
}
