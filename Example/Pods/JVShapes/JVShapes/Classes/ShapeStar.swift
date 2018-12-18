open class ShapeStar: Shape {
    
    public let points: Int
    public let extrusion: CGFloat
    
    public init(frame: CGRect, borderWidth: CGFloat, fillColor: UIColor, borderColor: UIColor, contentTypeColorChanger: ContentTypeColorChanger?, points: Int = 5, extrusion: CGFloat = 0.225) {
        self.points = points
        self.extrusion = extrusion
        super.init(frame: frame, borderWidth: borderWidth, fillColor: fillColor, borderColor: borderColor, contentTypeColorChanger: contentTypeColorChanger, contentType: .star)
    }
    
    public init(frame: CGRect, borderWidth: CGFloat, fillColor: UIColor, borderColor: UIColor, contentTypeColorChanger: ContentTypeColorChanger?, contentTypeShapeStarId: String) {
        let contentTypeShapeStar = ContentTypeShapeStar.getContentType(contentTypeId: contentTypeShapeStarId)
        
        self.points = contentTypeShapeStar.points
        self.extrusion = contentTypeShapeStar.extrusion
        
        super.init(frame: frame, borderWidth: borderWidth, fillColor: fillColor, borderColor: borderColor, contentTypeColorChanger: contentTypeColorChanger, contentType: .star)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func determinePath(frame: CGRect) -> CGPath {
        let path = UIBezierPath()
        let center = CGPoint(x: frame.width / 2.0, y: frame.height / 2.0)
        var angle = -CGFloat(.pi / 2.0)
        let angleIncrement = CGFloat(.pi * 2.0 / Double(points))
        let radius = frame.width / 2.0
        var firstPoint = true
        
        for _ in 1...points {
            let point = ShapeStar.pointFrom(angle, radius: radius, offset: center)
            let nextPoint = ShapeStar.pointFrom(angle + angleIncrement, radius: radius, offset: center)
            let midPoint = ShapeStar.pointFrom(angle + angleIncrement / 2.0, radius: extrusion * self.frame.height, offset: center)
            if firstPoint {
                firstPoint = false
                path.move(to: point)
            }
            path.addLine(to: midPoint)
            path.addLine(to: nextPoint)
            angle += angleIncrement
        }
        
        return path.cgPath
    }
    
    private static func pointFrom(_ angle: CGFloat, radius: CGFloat, offset: CGPoint) -> CGPoint {
        return CGPoint(x: radius * cos(angle) + offset.x, y: radius * sin(angle) + offset.y + offset.y * 0.075) // added offset to center the star... PLEASE FIX
    }
    
}
