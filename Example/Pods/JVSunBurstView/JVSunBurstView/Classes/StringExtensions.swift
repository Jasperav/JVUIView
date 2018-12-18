public extension String {
    var contentTypeSunBurstView: ContentTypeSunBurstView {
        get {
            return ContentTypeSunBurstView.getContentType(contentTypeId: self)
        }
    }
}
