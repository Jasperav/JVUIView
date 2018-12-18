import JVView

public class JVUIViewUtils {
    
    public static var contentTypeInfo = [String: [String: Any]]()
    
    public static func dynamicInit(contentType: ContentTypeJVUIView) -> JVUIView {
        if contentType is ContentTypeJVUIViewStacked {
            return JVUIViewStacked(contentType: contentType)
        }
        
        if contentType is ContentTypeJVUIViewTextContentBothSides {
            return JVUIViewTextContentBothSides(contentType: contentType)
        }
        
        if contentType is ContentTypeJVUIViewTextContentSide {
            return JVUIViewTextContentSide(contentType: contentType)
        }
        
        if contentType is ContentTypeJVUIViewText {
            return JVUIViewText(contentType: contentType)
        }
        
        if contentType is ContentTypeJVUIViewContent {
            return JVUIViewContent(contentType: contentType)
        }
        
        return JVUIView(contentType: contentType)
    }
    
    public static func getWidth(contentType: ContentTypeJVUIView) -> CGFloat {
        return getWidth(contentTypeId: contentType.contentTypeId!)
    }
    
    // BEWARE
    // This is dynamically chose the type for you.
    // If you initialize a JVUIView with contentType JVUIViewText, you get a WRONG value.
    public static func getWidth(contentTypeId: String) -> CGFloat {
        let contentTypeInfo = self.contentTypeInfo[contentTypeId]!

        return ceil((contentTypeInfo["size"] as! CGSize).width)
    }
    
    public static func getHeight(contentType: ContentTypeJVUIView) -> CGFloat {
        return getHeight(contentTypeId: contentType.contentTypeId!)
    }
    
    public static func getHeight(contentTypeId: String) -> CGFloat {
        let contentTypeInfo = self.contentTypeInfo[contentTypeId]!
        
        return ceil((contentTypeInfo["size"] as! CGSize).height)
    }
    
    public static func addSize(contentTypeId: String, size: CGSize) {
        contentTypeInfo[contentTypeId] = ["size" : size]
    }
    
}
