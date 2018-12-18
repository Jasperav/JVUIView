public struct ColorChanger {
    public let contentType: ContentTypeColorChanger
    
    public private(set) var currentColorIndex = 0
    public private(set) var fillColor = UIColor.clear
    public private(set) var borderColor = UIColor.clear
    
    public init(contentType: ContentTypeColorChanger) {
        self.contentType = contentType
        assert(contentType.fillColors.count > 1)
        assert(contentType.fillColors.count == contentType.borderColors.count)
        
        self.fillColor = contentType.fillColors[0].randomColor
        self.borderColor = contentType.borderColors[0].randomColor
    }
    
    public mutating func nextColors() {
        currentColorIndex += 1
        
        if currentColorIndex >= contentType.fillColors.count {
            currentColorIndex = 0
        }
        
        fillColor = contentType.fillColors[currentColorIndex].randomColor
        borderColor = contentType.borderColors[currentColorIndex].randomColor
    }
}
