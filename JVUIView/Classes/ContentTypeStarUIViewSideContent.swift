import JVView
import NVActivityIndicatorView
import JVContentType

public final class ContentTypeJVUIViewSideContent: ContentType, Copyable {

    public static var allTypes = Set<ContentTypeJVUIViewSideContent>()
    
    public var contentTypeId: String?
    public var image: UIImage? = nil
    public var contentTypeJVButton: ContentTypeJVButton? = nil
    public var NVActivityIndicatorType: NVActivityIndicatorType? = nil
    public var customView: UIView? = nil
    
    public init(contentTypeId: String?) {
        self.contentTypeId = contentTypeId
    }
    
    public init(contentTypeId: String?, image: UIImage) {
        self.contentTypeId = contentTypeId
        self.image = image
    }
    
    public init(contentTypeId: String?, image: UIImage, contentTypeJVButton: ContentTypeJVButton) {
        self.contentTypeId = contentTypeId
        self.image = image
        self.contentTypeJVButton = contentTypeJVButton
    }
    
    public init(contentTypeId: String?, NVActivityIndicatorType: NVActivityIndicatorType) {
        self.contentTypeId = contentTypeId
        self.NVActivityIndicatorType = NVActivityIndicatorType
    }
    
    public init(contentTypeId: String? = nil, customView: UIView) {
        self.contentTypeId = contentTypeId
        self.customView = customView
        fatalError() // I do not know if is a good idea to use this init since customView holds only a UIView
    }
    
    public init(old: ContentTypeJVUIViewSideContent, contentTypeId: String?) {
        self.contentTypeId = contentTypeId
        image = old.image
        contentTypeJVButton = old.contentTypeJVButton?.copy(contentTypeId: contentTypeId)
        NVActivityIndicatorType = old.NVActivityIndicatorType
        customView = old.customView
    }
}
