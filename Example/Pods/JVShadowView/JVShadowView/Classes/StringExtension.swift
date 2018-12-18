public extension String {
    var contentTypeJVShadowView: ContentTypeJVShadowView {
        get {
            return ContentTypeJVShadowView.getContentType(contentTypeId: self)
        }
    }
}
