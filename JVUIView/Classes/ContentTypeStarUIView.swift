import JVView
import JVGradientLayer
import JVResizableViewBorder
import JVContentType
import JVShadowView
import JVShapeHalfMoon
import JVShapes
import JVSunBurstView
import JVSizeable

open class ContentTypeJVUIView: Copyable, Sizeable {
    
    public static var allTypes = [ContentTypeJVUIView]()
    
    public var contentTypeId: String?
    
    public var cornerRadius: CGFloat?
    public var borderWidth: CGFloat?
    public var borderColor: CGColor?
    public var isRounded = false {
        didSet {
            if isRounded {
                cornerRadius = nil
            }
        }
    }
    
    public var minimumWidth: CGFloat?
    public var minimumHeight: CGFloat?
    public var useMinimumWidth: Bool?
    public var useMinimumHeight: Bool?
    
    public var backgroundColor: UIColor?
    public var backgroundImage: UIImage?
    public var backgroundImageAlpha: CGFloat?
    public var backgroundImageContentMode = UIView.ContentMode.scaleAspectFill
    public var backgroundContentTypeJVGradientLayer: [ContentTypeJVGradientLayer]?
    public var backgroundContentTypeJVGradientLayerPoint: ContentTypeJVGradientLayerPoint?
    
    public var gradientAnimationFlash: TimeInterval?
    
    public var contentTypeJVShadow: ContentTypeJVShadowView?
    public var contentTypeResizableViewBorder: ContentTypeResizableViewBorder?
    public var contentTypeUIRectEdges: ContentTypeUIRectEdges?
    public var contentTypeResizableViewBorderRoundedEdges: ContentTypeResizableViewBorderRoundedEdges?
    public var contentTypeShapeHalfMoon: ContentTypeShapeHalfMoon?
    public var contentTypeJVButton: ContentTypeJVButton?
    
    /// If this is filled in, the view should have a contentTypeJVShadow.
    /// The amount that is filled in, that should be between 0.0 and 1.0, will override the color of the star shadow
    /// The input is the background color, the output will dark the background color by this specified property.
    public var baseBackgroundColorForJVShadowByPercent: CGFloat?
    
    /// If this is filled in, the view should have a star gradient layer attached to it.
    /// It will automatically give the background star gradient layer some brightness.
    public var baseBackgroundColorForBackgroundGradientLayer: (firstColorAdjustedBrightness: CGFloat, lastColorAdjustedBrightness: CGFloat)?
    
    public var contentTypeSunBurstView: ContentTypeSunBurstView?
    public var contentTypeShapeSpawner: ContentTypeShapeSpawner?
    public var shapeGroupIdForContentTypeShapeSpawner: String?
    public var contentTypeJVGradientLayerBackgroundActiveState: [ContentTypeJVGradientLayer]?
    public var contentTypeJVGradientLayerBackgroundPointActiveState: ContentTypeJVGradientLayerPoint?
    
    public var addShapeSpawnerView = false
    
    /// The JVUIView that will be on top of the current JVUIView. Used to e.g. used to display the seconds left for the free coins view.
    /// Control this view with the JVUIViewDelegate
    public var contentTypeJVUIViewOnTop: ContentTypeJVUIView?
    
    public init(contentTypeId: String?) {
        self.contentTypeId = contentTypeId
    }
    
    public required init(old: ContentTypeJVUIView, contentTypeId: String? = nil) {
        self.contentTypeId = contentTypeId
        
        cornerRadius = old.cornerRadius
        borderWidth = old.borderWidth
        borderColor = old.borderColor
        isRounded = old.isRounded
        
        minimumWidth = old.minimumWidth
        minimumHeight = old.minimumHeight
        useMinimumWidth = old.useMinimumWidth
        useMinimumHeight = old.useMinimumHeight
        
        backgroundColor = old.backgroundColor
        backgroundImage = old.backgroundImage
        backgroundImageAlpha = old.backgroundImageAlpha
        backgroundContentTypeJVGradientLayer = old.backgroundContentTypeJVGradientLayer?.copy()
        backgroundContentTypeJVGradientLayerPoint = old.backgroundContentTypeJVGradientLayerPoint
        
        gradientAnimationFlash = old.gradientAnimationFlash
        
        contentTypeJVShadow = old.contentTypeJVShadow?.copy()
        contentTypeResizableViewBorder = old.contentTypeResizableViewBorder
        contentTypeUIRectEdges = old.contentTypeUIRectEdges
        contentTypeResizableViewBorderRoundedEdges = old.contentTypeResizableViewBorderRoundedEdges
        contentTypeShapeHalfMoon = old.contentTypeShapeHalfMoon
        contentTypeJVButton = old.contentTypeJVButton?.copy(contentTypeId: contentTypeId)
        contentTypeSunBurstView = old.contentTypeSunBurstView
        contentTypeShapeSpawner = old.contentTypeShapeSpawner
        contentTypeJVGradientLayerBackgroundActiveState = old.contentTypeJVGradientLayerBackgroundActiveState
        contentTypeJVGradientLayerBackgroundPointActiveState = old.contentTypeJVGradientLayerBackgroundPointActiveState
        baseBackgroundColorForJVShadowByPercent = old.baseBackgroundColorForJVShadowByPercent
        baseBackgroundColorForBackgroundGradientLayer = old.baseBackgroundColorForBackgroundGradientLayer
        backgroundImageContentMode = old.backgroundImageContentMode
    }
    
    public static func getContentType(contentTypeId: String) -> ContentTypeJVUIView {
        return allTypes.first { $0.contentTypeId! == contentTypeId }!
    }
    
    public func addToAllTypes() {
        assert(contentTypeId != nil)
        assert(!ContentTypeJVUIView.allTypes.contains { $0.contentTypeId! == contentTypeId })
        ContentTypeJVUIView.allTypes.append(self)
    }
    
    /// Calculate the height and width for this content type.
    /// The results are stored in a dictionary in JVUIViewUtils.
    public func calculateSize() {
        assert(contentTypeId != nil, "The sizes gets stored in a dictionariy. The only way to look this up is through the contentTypeId. Therefore this should be filled.")
        let size = CGSize(width: width, height: height)
        
        JVUIViewUtils.addSize(contentTypeId: contentTypeId!, size: size)
    }
    
    public var height: CGFloat {
        get {
            if self is ContentTypeJVUIViewStacked {
                return JVUIViewStacked.getHeight(contentType: self as! ContentTypeJVUIViewStacked)
            }
            
            if self is ContentTypeJVUIViewTextContentBothSides {
                return JVUIViewText.getHeight(contentType: self as! ContentTypeJVUIViewText)
            }
            
            if self is ContentTypeJVUIViewTextContentSide {
                return JVUIViewText.getHeight(contentType: self as! ContentTypeJVUIViewText)
            }
            
            if self is ContentTypeJVUIViewText {
                return JVUIViewText.getHeight(contentType: self as! ContentTypeJVUIViewText)
            }
            
            return JVUIView.getHeight(contentType: self)
        }
    }
    
    public var width: CGFloat {
        get {
            if self is ContentTypeJVUIViewStacked {
                return JVUIViewStacked.getWidth(contentType: self as! ContentTypeJVUIViewStacked)
            }
            
            if self is ContentTypeJVUIViewTextContentBothSides {
                return JVUIViewTextContentBothSides.getWidth(contentType: self as! ContentTypeJVUIViewTextContentBothSides)
            }
            
            if self is ContentTypeJVUIViewTextContentSide {
                return JVUIViewTextContentSide.getWidth(contentType: self as! ContentTypeJVUIViewTextContentSide)
            }
            
            if self is ContentTypeJVUIViewText {
                return JVUIViewText.getWidth(contentType: self as! ContentTypeJVUIViewText)
            }
            
            return JVUIView.getWidth(contentType: self)
        }
    }
}
