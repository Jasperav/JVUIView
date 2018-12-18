import UIKit
import JVView
import JVImageDownloader
import JVConstraintEdges
import JVCurrentDevice
import JVUIViewExtensions

open class JVUIViewTextContentBothSides: JVUIViewTextContentSide {
    
    public var contentTypeSideOpposite: ContentTypeJVUIViewSide!
    public var imageSideOpposite: UIImageView!
    public var buttonSideOpposite: JVButton!
    public var loadingOpposite: ImageDownloader!
    public weak var viewSideOpposite: UIView!
    
    override func getEdgesText() -> ConstraintEdges {
        return ConstraintEdges(leading: nil,
                               trailing: nil,
                               top: contentTypeText.constraintEdges.top ?? 0,
                               bottom: contentTypeText.constraintEdges.bottom ?? 0)
    }
    
    public static func getWidth(contentType: ContentTypeJVUIViewTextContentBothSides) -> CGFloat {
        let textWidthAndContent = super.getWidth(contentType: contentType)
        
        let textHeight = JVUIViewText.getHeight(contentType: contentType) - contentType.constraintEdges.height
        
        let contentSideWidth = contentType.contentTypeJVUIViewSide.constraintEdges.width + contentType.contentTypeJVUIViewSide.constraintEdges.height + textHeight
        
        return ceil(textWidthAndContent + contentSideWidth)
    }
    
    // Maybe this will not work out well
    public override var width: CGFloat {
        get {
            let textWidthAndContent = super.width
            let contentSideWidth = contentTypeSideOpposite.constraintEdges.width + contentTypeSideOpposite.constraintEdges.height + label.height
            
            return textWidthAndContent + contentSideWidth
        }
    }
    
    public override func getEdgesForButton() -> ConstraintEdges {
        return ConstraintEdges(leading: nil, trailing: nil, top: 0, bottom: 0)
    }
    
    open override func setContentType() {
        super.setContentType()
        contentTypeSideOpposite = (contentType as! ContentTypeJVUIViewTextContentBothSides).contentTypeJVUIViewSideOpposite
        
        if let NVActivityIndicatorType = contentTypeSideOpposite.contentTypeJVUIViewSideContent.NVActivityIndicatorType {
            loadingOpposite = ImageDownloader(NVActivityIndicatorType: NVActivityIndicatorType)
            viewSideOpposite = loadingOpposite
        } else if let contentTypeJVButton = contentTypeSideOpposite.contentTypeJVUIViewSideContent.contentTypeJVButton {
            buttonSideOpposite = JVButton(contentType: contentTypeJVButton)
            buttonSideOpposite.imageView?.contentMode = .scaleAspectFit
            buttonSideOpposite.setImage(contentTypeSideOpposite.contentTypeJVUIViewSideContent.image!, for: .normal)
            viewSideOpposite = buttonSideOpposite
        } else {
            let image = contentTypeSideOpposite.contentTypeJVUIViewSideContent.image!
            imageSideOpposite = getImageView(image: image)
            viewSideOpposite = imageSideOpposite
        }
        
        activeContentSideConstrains(view: viewSideOpposite, constrains: contentTypeSideOpposite.constraintEdges, sideLeft: !(contentType as! ContentTypeJVUIViewTextContentBothSides).contentIsOnLeftSide, edges: contentTypeSideOpposite.constraintEdges)
        
        if button != nil {
            if (contentType as! ContentTypeJVUIViewTextContentSide).contentIsOnLeftSide {
                NSLayoutConstraint(item: button,
                                   attribute: .trailing,
                                   relatedBy: .equal,
                                   toItem: viewSideOpposite,
                                   attribute: .leading,
                                   multiplier: 1,
                                   constant: 0).isActive = true
            } else {
                NSLayoutConstraint(item: button,
                                   attribute: .leading,
                                   relatedBy: .equal,
                                   toItem: viewSideOpposite,
                                   attribute: .trailing,
                                   multiplier: 1,
                                   constant: 0).isActive = true
            }
        }
    }
    
}

