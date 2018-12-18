import JVView
import NVActivityIndicatorView

/// A starUIView class with content inside of it which can be: an image, a NVActivityView or JVButton
open class JVUIViewContent: JVUIView {
    
    public var contentImage: UIImageView!
    public var contentButton: JVButton!
    public var contentLoader: NVActivityIndicatorView!
    
    open override func setContentType() {
        super.setContentType()
        
        let contentType = (self.contentType as! ContentTypeJVUIViewContent).contentTypeJVUIViewContent!
        
        let contentTypeContent = contentType.contentTypeJVUIViewSideContent!
        
        let view: UIView
        if let contentTypeJVButton = contentTypeContent.contentTypeJVButton {
            contentButton = JVButton(contentType: contentTypeJVButton)
            contentButton.setImage(contentTypeContent.image!, for: .normal)
            
            view = contentButton
        } else if let image = contentTypeContent.image {
            contentImage = UIImageView(image: image)
            
            view = contentImage
        } else {
            let nvActivityIndicatorView = contentTypeContent.NVActivityIndicatorType!
            contentLoader = NVActivityIndicatorView(frame: CGRect.zero, type: nvActivityIndicatorView, color: .black, padding: nil)
            
            view = contentLoader
            
        }
        
        view.fill(toSuperview: contentView, edges: contentType.constraintEdges)
    }
    
}
