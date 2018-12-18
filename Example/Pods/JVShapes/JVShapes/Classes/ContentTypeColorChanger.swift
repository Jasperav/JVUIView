import JVContentType
import JVColorBlender
import JVRandomNumberGenerator

/// Always create a copy of this class when you acutally use an instance of it
public struct ContentTypeColorChanger: ContentType {
    
    public static var allTypes = Set<ContentTypeColorChanger>()
    
    public var contentTypeId: String?
    
    // !Make sure fillColors and borderColors do have the same amount of elements!
    // fillColor and borderColor come together. This means you can group look-a-like colors by putting them in the same index
    public var fillColors: [ContentTypeColorBlender]!
    public var borderColors: [ContentTypeColorBlender]!
    public var randomColorChangeRate: RandomNumberDouble!
    public var randomColorChangeDuration: RandomNumberDouble!
    
    public init(contentTypeId: String,
                contentTypeColorBlenderGroupIdBorderColor: String,
                contentTypeColorBlenderGroupIdFillColor: String,
                randomColorChangeRate: RandomNumberDouble,
                randomColorChangeDuration: RandomNumberDouble) {
        self.contentTypeId = contentTypeId
        self.fillColors = ContentTypeColorBlender.getContentTypes(contentTypeGroupId: contentTypeColorBlenderGroupIdFillColor)
        self.borderColors = ContentTypeColorBlender.getContentTypes(contentTypeGroupId: contentTypeColorBlenderGroupIdBorderColor)
        self.randomColorChangeRate = randomColorChangeRate
        self.randomColorChangeDuration = randomColorChangeDuration
    }

    public init(contentTypeId: String?) {
        self.contentTypeId = contentTypeId
    }

}
