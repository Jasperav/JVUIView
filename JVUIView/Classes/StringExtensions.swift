public extension String {
    var contentTypeJVUIView: ContentTypeJVUIView {
        get {
            return ContentTypeJVUIView.getContentType(contentTypeId: self)
        }
    }
    
    var contentTypeJVUIViewText: ContentTypeJVUIViewText {
        get {
            return ContentTypeJVUIView.getContentType(contentTypeId: self) as! ContentTypeJVUIViewText
        }
    }
    
    var contentTypeJVUIViewStacked: ContentTypeJVUIViewStacked {
        get {
            return ContentTypeJVUIViewStacked.getContentType(contentTypeId: self) as! ContentTypeJVUIViewStacked
        }
    }
    
    var contentTypeJVUIViewSide: ContentTypeJVUIViewSide {
        get {
            return ContentTypeJVUIViewSide.getContentType(contentTypeId: self)
        }
    }
    
    var contentTypeJVUIViewSideContent: ContentTypeJVUIViewSideContent {
        get {
            return ContentTypeJVUIViewSideContent.getContentType(contentTypeId: self)
        }
    }
    
    var contentTypeJVUIViewDoubleText: ContentTypeJVUIViewDoubleText {
        get {
            return ContentTypeJVUIViewDoubleText.getContentType(contentTypeId: self) as! ContentTypeJVUIViewDoubleText
        }
    }
    
    var contentTypeJVUIViewContent: ContentTypeJVUIViewContent {
        get {
            return ContentTypeJVUIViewContent.getContentType(contentTypeId: self) as! ContentTypeJVUIViewContent
        }
    }
}
