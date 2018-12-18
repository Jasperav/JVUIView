import JVImageDownloader
import JVView
import JVConstraintEdges

open class JVUIViewTextContentTop: JVUIViewText {
    
    public var contentTypeTop: ContentTypeJVUIViewSide!
    public var imageTop: UIImageView!
    public var buttonTop: JVButton!
    public var loadingTop: ImageDownloader!
    public weak var viewTop: UIView!
    
    override func getEdgesText() -> ConstraintEdges {
        contentTypeText.constraintEdges.minus(edge: .top)
        return contentTypeText.constraintEdges
    }
    
    open override func setContentType() {
        super.setContentType()
        contentTypeTop = (contentType as! ContentTypeJVUIViewTextContentSide).contentTypeJVUIViewSide
        
        if let NVActivityIndicatorType = contentTypeTop.contentTypeJVUIViewSideContent.NVActivityIndicatorType {
            loadingTop = ImageDownloader(NVActivityIndicatorType: NVActivityIndicatorType)
            viewTop = loadingTop
        } else if let contentTypeJVButton = contentTypeTop.contentTypeJVUIViewSideContent.contentTypeJVButton {
            buttonTop = JVButton(contentType: contentTypeJVButton)
            buttonTop.imageView?.contentMode = .scaleAspectFit
            buttonTop.setImage(contentTypeTop.contentTypeJVUIViewSideContent.image!, for: .normal)
            viewTop = buttonTop
        } else {
            let imageView = UIImageView(image: contentTypeTop.contentTypeJVUIViewSideContent.image!)
            imageView.contentMode = .scaleAspectFit
            imageTop = imageView
            viewTop = imageTop
        }
        
        let copyEdges = contentTypeTop.constraintEdges
        
        contentTypeTop.constraintEdges.minus(edge: .bottom)
        
        viewTop.fill(toSuperview: self, edges: contentTypeTop.constraintEdges)
        
        NSLayoutConstraint(item: viewTop, attribute: .bottom, relatedBy: .equal, toItem: label, attribute: .top, multiplier: 1, constant: copyEdges.bottom ?? 0).isActive = true
    }
    
    
}

