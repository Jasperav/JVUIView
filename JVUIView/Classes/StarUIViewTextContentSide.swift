import UIKit
import JVView
import JVImageDownloader
import JVConstraintEdges
import JVCurrentDevice
import JVUIViewExtensions
import JVFontUtils

open class JVUIViewTextContentSide: JVUIViewText {
    
    public var contentTypeSide: ContentTypeJVUIViewSide!
    public var imageSide: UIImageView!
    public var buttonSide: JVButton!
    public var loadingSide: ImageDownloader!
    public weak var viewSide: UIView!
    
    internal static func getFrameText(contentTypeLabel: ContentTypeJVLabel) -> (height: CGFloat, width: CGFloat) {
        assert(contentTypeLabel.initialText != nil)
        return ContentTypeJVLabel.getSizeText(contentTypeLabel: contentTypeLabel)
    }
    
    internal static func getWidthContent(contentType: ContentTypeJVUIViewTextContentSide) -> CGFloat {
        let contentTypeLabel = contentType.contentTypeJVLabel!
        let textFrame = getFrameText(contentTypeLabel: contentTypeLabel)
        
        return textFrame.height + contentType.contentTypeJVUIViewSide.constraintEdges.height
    }
    
    public static func getWidth(contentType: ContentTypeJVUIViewTextContentSide) -> CGFloat {
        let textWidth = JVUIViewText.getWidth(contentType: contentType)
        let textHeight = JVUIViewText.getHeight(contentType: contentType) - contentType.constraintEdges.height
        
        let contentSideWidth = contentType.contentTypeJVUIViewSide.constraintEdges.width + contentType.contentTypeJVUIViewSide.constraintEdges.height + textHeight
        
        return ceil(textWidth + contentSideWidth)
    }
    
    public override var width: CGFloat {
        get {
            let textWidth = super.width
            let contentSideWidth = contentTypeSide.constraintEdges.width + contentTypeSide.constraintEdges.height + label.height
            
            return textWidth + contentSideWidth
        }
    }
    
    override func getEdgesText() -> ConstraintEdges {
        if (contentType as! ContentTypeJVUIViewTextContentSide).contentIsOnLeftSide {
            return ConstraintEdges(leading: nil,
                                   trailing: contentTypeText.constraintEdges.trailing ?? 0,
                                   top: contentTypeText.constraintEdges.top ?? 0,
                                   bottom: contentTypeText.constraintEdges.bottom ?? 0)
        } else {
            return ConstraintEdges(leading: contentTypeText.constraintEdges.leading ?? 0,
                                   trailing: nil,
                                   top: contentTypeText.constraintEdges.top ?? 0,
                                   bottom: contentTypeText.constraintEdges.bottom ?? 0)
        }
    }
    
    public override func getEdgesForButton() -> ConstraintEdges {
        if (contentType as! ContentTypeJVUIViewTextContentSide).contentIsOnLeftSide {
            return ConstraintEdges(leading: nil, trailing: 0, top: 0, bottom: 0)
        } else {
            return ConstraintEdges(leading: 0, trailing: nil, top: 0, bottom: 0)
        }
    }
    
    open override func setContentType() {
        super.setContentType()
        contentTypeSide = (contentType as! ContentTypeJVUIViewTextContentSide).contentTypeJVUIViewSide
        
        if let NVActivityIndicatorType = contentTypeSide.contentTypeJVUIViewSideContent.NVActivityIndicatorType {
            loadingSide = ImageDownloader(NVActivityIndicatorType: NVActivityIndicatorType)
            viewSide = loadingSide
        } else if let contentTypeJVButton = contentTypeSide.contentTypeJVUIViewSideContent.contentTypeJVButton {
            buttonSide = JVButton(contentType: contentTypeJVButton)
            buttonSide.imageView?.contentMode = .scaleAspectFit
            buttonSide.setImage(contentTypeSide.contentTypeJVUIViewSideContent.image, for: .normal)
            viewSide = buttonSide
        } else {
            let image = contentTypeSide.contentTypeJVUIViewSideContent.image!
            imageSide = getImageView(image: image)
            viewSide = imageSide
        }
        
        activeContentSideConstrains(view: viewSide, constrains: contentTypeSide.constraintEdges, sideLeft: (contentType as! ContentTypeJVUIViewTextContentSide).contentIsOnLeftSide, edges: contentTypeSide.constraintEdges)
        
        if button != nil {
            if (contentType as! ContentTypeJVUIViewTextContentSide).contentTypeJVUIViewSide.contentTypeJVUIViewSideContent.contentTypeJVButton == nil {
                // We do not want the content prevents the button to be pressed.
                if (contentType as! ContentTypeJVUIViewTextContentSide).contentIsOnLeftSide {
                    NSLayoutConstraint(item: button,
                                       attribute: .leading,
                                       relatedBy: .equal,
                                       toItem: viewSide,
                                       attribute: .leading,
                                       multiplier: 1,
                                       constant: 0).isActive = true
                } else {
                    NSLayoutConstraint(item: button,
                                       attribute: .trailing,
                                       relatedBy: .equal,
                                       toItem: viewSide,
                                       attribute: .trailing,
                                       multiplier: 1,
                                       constant: 0).isActive = true
                }
                return
            }
            if (contentType as! ContentTypeJVUIViewTextContentSide).contentIsOnLeftSide {
                NSLayoutConstraint(item: button,
                                   attribute: .leading,
                                   relatedBy: .equal,
                                   toItem: viewSide,
                                   attribute: .trailing,
                                   multiplier: 1,
                                   constant: 0).isActive = true
            } else {
                NSLayoutConstraint(item: button,
                                   attribute: .trailing,
                                   relatedBy: .equal,
                                   toItem: viewSide,
                                   attribute: .leading,
                                   multiplier: 1,
                                   constant: 0).isActive = true
            }
        }
        
    }
    
    internal func activeContentSideConstrains(view: UIView, constrains: ConstraintEdges, sideLeft: Bool, edges: ConstraintEdges) {
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setHuggingAndCompression(to: 2)
        view.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: view,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: label,
                               attribute: .top,
                               multiplier: 1,
                               constant: -(edges.top ?? 0)),
            NSLayoutConstraint(item: view,
                               attribute: .bottom,
                               relatedBy: .equal,
                               toItem: label,
                               attribute: .bottom,
                               multiplier: 1,
                               constant: (edges.bottom ?? 0)),
            NSLayoutConstraint(item: view,
                               attribute: .width,
                               relatedBy: .equal,
                               toItem: viewSide,
                               attribute: .height,
                               multiplier: 1,
                               constant: 0),
            NSLayoutConstraint(item: view,
                               attribute: .centerY,
                               relatedBy: .equal,
                               toItem: label,
                               attribute: .centerY,
                               multiplier: 1,
                               constant: 0)
            ])
        
        if sideLeft {
            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: view,
                                   attribute: .leading,
                                   relatedBy: .equal,
                                   toItem: self,
                                   attribute: .leading,
                                   multiplier: 1,
                                   constant:  edges.leading ?? 0),
                NSLayoutConstraint(item: view,
                                   attribute: .trailing,
                                   relatedBy: .equal,
                                   toItem: label,
                                   attribute: .leading,
                                   multiplier: 1,
                                   constant: -((super.getEdgesText().leading ?? 0) + (edges.leading ?? 0)))
                ])
        } else {
            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: view,
                                   attribute: .trailing,
                                   relatedBy: .equal,
                                   toItem: self,
                                   attribute: .trailing,
                                   multiplier: 1,
                                   constant:  -(edges.trailing ?? 0)),
                NSLayoutConstraint(item: view,
                                   attribute: .leading,
                                   relatedBy: .equal,
                                   toItem: label,
                                   attribute: .trailing,
                                   multiplier: 1,
                                   constant: ((super.getEdgesText().trailing ?? 0) + (edges.trailing ?? 0)))
                ])
        }
    }
    
    private func prepareView(view: UIView) -> UIView {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setHuggingAndCompression(to: 248)
        return view
    }
    
    internal func getImageView(image: UIImage) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return prepareView(view: imageView) as! UIImageView
    }
}
