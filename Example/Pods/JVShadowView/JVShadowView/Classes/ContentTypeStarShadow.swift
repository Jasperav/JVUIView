import JVContentType

public struct ContentTypeJVShadowView: ContentType {
    
    public static var allTypes = Set<ContentTypeJVShadowView>()
    
    public var contentTypeId: String?
    public var color: CGColor
    public var radius: CGFloat
    public var offSet: CGSize
    public var opacity: Float
    public var shouldRasterize: Bool
    public var rasterizationScale: CGFloat
    public var enlargeBoundsByAbsoluteValue: CGFloat
    
    /// Value must be between 0.0 and 1.0
    public var darkColorByPercent: CGFloat = 0.0
    
    public init(contentTypeId: String?, color: CGColor, radius: CGFloat, offSet: CGSize, opacity: Float, enlargeBoundsByAbsoluteValue: CGFloat = 1, shouldRasterize: Bool = false, rasterizationScale: CGFloat = UIScreen.main.scale) {
        self.contentTypeId = contentTypeId
        self.color = color
        self.radius = radius
        self.offSet = offSet
        self.opacity = opacity
        self.enlargeBoundsByAbsoluteValue = enlargeBoundsByAbsoluteValue
        self.shouldRasterize = shouldRasterize
        self.rasterizationScale = rasterizationScale
    }

}
