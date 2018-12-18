import JVContentType
import JVColorBlender
import JVRandomNumberGenerator

public struct ContentTypeShape: ContentTypeGroup {
    
    public static var allTypes = Set<ContentTypeShape>()
    
    public var contentTypeId: String?
    public var contentTypeGroupId: [String]?
    public var spawnPropability: Double = 1
    public var shape: Shapes!
    public var borderWidth: CGFloat = 1
    public var contentTypeColorBlenderBorderColor: ContentTypeColorBlender!
    public var contentTypeColorBlenderFillColor: ContentTypeColorBlender!
    public var contentTypeColorChanger: ContentTypeColorChanger?
    
    public init(contentTypeId: String?,
                contentTypeGroupId: [String]?,
                spawnPropability: Double,
                shape: Shapes,
                borderWidth: CGFloat,
                contentTypeColorBlenderBorderColor: ContentTypeColorBlender,
                contentTypeColorBlenderFillColor: ContentTypeColorBlender) {
        self.contentTypeId = contentTypeId
        self.contentTypeGroupId = contentTypeGroupId
        self.spawnPropability = spawnPropability
        self.shape = shape
        self.borderWidth = borderWidth
        self.contentTypeColorBlenderBorderColor = contentTypeColorBlenderBorderColor
        self.contentTypeColorBlenderFillColor = contentTypeColorBlenderFillColor
    }
    
    public init(contentTypeId: String?) {
        self.contentTypeId = contentTypeId
    }
    
    public func getShape(size: CGFloat, fixedFillColor: UIColor? = nil, fixedBorderColor: UIColor? = nil, contentTypeColorChanger: ContentTypeColorChanger?) -> Shape {
        let frame = CGRect(x: 0, y: 0, width: size, height: size)
        switch shape! {
        case .circle:
            return ShapeCircle(frame: frame,
                               borderWidth: borderWidth,
                               fillColor: fixedFillColor ?? contentTypeColorBlenderFillColor.randomColor,
                               borderColor: fixedBorderColor ?? contentTypeColorBlenderBorderColor.randomColor,
                               contentTypeColorChanger: contentTypeColorChanger)
        case .diamond:
            return ShapeDiamond(frame: frame,
                                borderWidth: borderWidth,
                                fillColor: fixedFillColor ?? contentTypeColorBlenderFillColor.randomColor,
                                borderColor: fixedBorderColor ?? contentTypeColorBlenderBorderColor.randomColor,
                                contentTypeColorChanger: contentTypeColorChanger)
        case .square:
            return ShapeSquare(frame: frame,
                               borderWidth: borderWidth,
                               fillColor: fixedFillColor ?? contentTypeColorBlenderFillColor.randomColor,
                               borderColor: fixedBorderColor ?? contentTypeColorBlenderBorderColor.randomColor,
                               contentTypeColorChanger: contentTypeColorChanger)
        case .star:
            return ShapeStar(frame: frame,
                             borderWidth: borderWidth,
                             fillColor: fixedFillColor ?? contentTypeColorBlenderFillColor.randomColor,
                             borderColor: fixedBorderColor ?? contentTypeColorBlenderBorderColor.randomColor,
                             contentTypeColorChanger: contentTypeColorChanger)
        case .triangle:
            return ShapeTriangle(frame: frame,
                                 borderWidth: borderWidth,
                                 fillColor: fixedFillColor ?? contentTypeColorBlenderFillColor.randomColor,
                                 borderColor: fixedBorderColor ?? contentTypeColorBlenderBorderColor.randomColor,
                                 contentTypeColorChanger: contentTypeColorChanger)
        }
    }

}
