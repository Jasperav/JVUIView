public extension String {
    var contentTypeResizableViewBorder: ContentTypeResizableViewBorder {
        get {
            return ContentTypeResizableViewBorder.getContentType(contentTypeId: self)
        }
    }
    
    var contentTypeResizableViewBorderRoundedEdges: ContentTypeResizableViewBorderRoundedEdges {
        get {
            return ContentTypeResizableViewBorderRoundedEdges.getContentType(contentTypeId: self)
        }
    }
    
    var contentTypeUIRectEdges: ContentTypeUIRectEdges {
        get {
            return ContentTypeUIRectEdges.getContentType(contentTypeId: self)
        }
    }
}
