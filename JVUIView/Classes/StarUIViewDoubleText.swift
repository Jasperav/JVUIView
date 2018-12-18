import JVConstraintEdges
import JVView

open class JVUIViewDoubleText: JVUIViewText {
    var contentTypeDoubleText: ContentTypeJVUIViewDoubleText!
    
    public var labelRight: JVLabel!
    
    /// Implicitly unwrapped but it is not always a counter
    public var countLabelRight: JVLabelCounter!
    
    open override func setContentType() {
        super.setContentType()
        contentTypeDoubleText = contentType as! ContentTypeJVUIViewDoubleText
        
        labelRight = JVLabelUtils.dynamicInit(contentType: contentTypeDoubleText.contentTypeJVLabelRight)
        labelRight.setCompressionResistance(to: 1)
        labelRight.fill(toSuperview: contentView, edges: contentTypeDoubleText.constraintEdges.min(.left))
        labelRight.setContentHugging(to: 1)
        labelRight.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: contentTypeDoubleText.constraintEdges.leading!).isActive = true

        countLabelRight = labelRight as? JVLabelCounter
    }
    
    override func getEdgesText() -> ConstraintEdges {
        return contentTypeText.constraintEdges.min(.right)
    }
}
